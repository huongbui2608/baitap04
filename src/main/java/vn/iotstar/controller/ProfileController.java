package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.model.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.CloudinaryUtil;
import vn.iotstar.util.EmailUtil;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 20     // 20MB
)
@WebServlet(urlPatterns = { "/profile", "/profile/verify-email" })
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User account = (session != null) ? (User) session.getAttribute("account") : null;

        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String uri = req.getRequestURI();

        if (uri.endsWith("/profile/verify-email")) {
            req.getRequestDispatcher("/views/verify-email.jsp").forward(req, resp);
            return;
        }

        // Lấy thông tin mới nhất từ CSDL
        User freshUser = userService.get(account.getUserName());
        if (freshUser != null) {
            session.setAttribute("account", freshUser);
            req.setAttribute("user", freshUser);
        } else {
            req.setAttribute("user", account);
        }

        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User account = (session != null) ? (User) session.getAttribute("account") : null;

        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String uri = req.getRequestURI();

        // Xử lý xác nhận OTP đổi Email mới
        if (uri.endsWith("/profile/verify-email")) {
            String otp = req.getParameter("otp");
            String sessionOtp = (String) session.getAttribute("pendingEmailOtp");
            String newEmail = (String) session.getAttribute("pendingNewEmail");

            if (otp == null || otp.trim().isEmpty() || sessionOtp == null) {
                req.setAttribute("alert", "Vui lòng nhập mã OTP xác thực!");
                req.getRequestDispatcher("/views/verify-email.jsp").forward(req, resp);
                return;
            }

            if (otp.trim().equals(sessionOtp)) {
                // OTP hợp lệ -> Cập nhật email mới vào CSDL
                userService.updateEmail(account.getId(), newEmail);
                account.setEmail(newEmail);
                session.setAttribute("account", account);

                session.removeAttribute("pendingEmailOtp");
                session.removeAttribute("pendingNewEmail");

                req.setAttribute("message", "Xác thực OTP thành công! Email của bạn đã được cập nhật thành: " + newEmail);
                req.setAttribute("user", account);
                req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            } else {
                req.setAttribute("alert", "Mã xác thực OTP không chính xác hoặc đã hết hạn!");
                req.getRequestDispatcher("/views/verify-email.jsp").forward(req, resp);
            }
            return;
        }

        // Xử lý cập nhật thông tin Profile
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        // VALIDATION (Yêu cầu 2)
        if (fullname == null || fullname.trim().length() < 2) {
            req.setAttribute("alert", "Họ và tên không được để trống và phải có ít nhất 2 ký tự!");
            req.setAttribute("user", account);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            return;
        }

        if (phone == null || !phone.matches("^(0|\\+84)[3|5|7|8|9][0-9]{8}$")) {
            req.setAttribute("alert", "Số điện thoại không hợp lệ! Vui lòng nhập số điện thoại Việt Nam (10 chữ số).");
            req.setAttribute("user", account);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            return;
        }

        if (email == null || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            req.setAttribute("alert", "Định dạng email không hợp lệ!");
            req.setAttribute("user", account);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
            return;
        }

        // Xử lý upload ảnh đại diện lên Cloudinary bằng Multipart (Yêu cầu 3)
        String avatarUrl = null;
        try {
            Part part = req.getPart("avatarFile");
            if (part != null && part.getSize() > 0) {
                String originalFilename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                try (InputStream is = part.getInputStream()) {
                    byte[] bytes = is.readAllBytes();
                    avatarUrl = CloudinaryUtil.uploadImage(bytes, originalFilename);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (avatarUrl == null || avatarUrl.isEmpty()) {
            avatarUrl = account.getAvatar(); // Giữ avatar cũ nếu không tải ảnh mới
        }

        // Kiểm tra xem người dùng có đổi sang email mới hay không
        boolean isEmailChanged = !email.trim().equalsIgnoreCase(account.getEmail());

        if (isEmailChanged) {
            // Kiểm tra xem email mới đã bị ai đăng ký chưa
            User existUser = userService.getByEmail(email.trim());
            if (existUser != null && existUser.getId() != account.getId()) {
                req.setAttribute("alert", "Email '" + email.trim() + "' đã được sử dụng bởi một tài khoản khác!");
                req.setAttribute("user", account);
                req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
                return;
            }

            // Sinh mã OTP và gửi đến EMAIL MỚI (Yêu cầu 3)
            String otp = EmailUtil.generateOtp(6);
            EmailUtil.sendOtp(email.trim(), otp, "Xác nhận cập nhật địa chỉ Email mới");

            // Cập nhật fullname, phone, avatar trước
            userService.updateProfile(account.getId(), fullname.trim(), phone.trim(), avatarUrl);
            account.setFullName(fullname.trim());
            account.setPhone(phone.trim());
            account.setAvatar(avatarUrl);
            session.setAttribute("account", account);

            // Lưu thông tin chờ OTP email mới vào session
            session.setAttribute("pendingNewEmail", email.trim());
            session.setAttribute("pendingEmailOtp", otp);

            resp.sendRedirect(req.getContextPath() + "/profile/verify-email");
            return;
        }

        // Nếu không đổi email, cập nhật trực tiếp
        userService.updateProfile(account.getId(), fullname.trim(), phone.trim(), avatarUrl);
        account.setFullName(fullname.trim());
        account.setPhone(phone.trim());
        account.setAvatar(avatarUrl);
        session.setAttribute("account", account);

        req.setAttribute("message", "Cập nhật hồ sơ cá nhân thành công!");
        req.setAttribute("user", account);
        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }
}
