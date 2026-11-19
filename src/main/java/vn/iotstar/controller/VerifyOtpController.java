package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.model.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.EmailUtil;

import java.io.IOException;

@WebServlet("/verify-otp")
public class VerifyOtpController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String usernameParam = req.getParameter("username");
        HttpSession session = req.getSession(false);

        String username = null;
        if (session != null && session.getAttribute("pendingUsername") != null) {
            username = (String) session.getAttribute("pendingUsername");
        } else if (usernameParam != null && !usernameParam.trim().isEmpty()) {
            username = usernameParam.trim();
        }

        String action = req.getParameter("action");
        if ("resend".equalsIgnoreCase(action) && username != null) {
            User user = userService.get(username);
            if (user != null) {
                String newOtp = EmailUtil.generateOtp(6);
                user.setCode(newOtp);
                // Cập nhật mã mới
                userService.sendForgotPasswordOtp(username);
                req.setAttribute("message", "Đã gửi lại mã OTP mới đến email của bạn!");
            }
        }

        req.setAttribute("username", username);
        req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String otp = req.getParameter("otp");

        if (username == null || username.trim().isEmpty() || otp == null || otp.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập đầy đủ tên đăng nhập và mã OTP!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        boolean verified = userService.verifyOtp(username.trim(), otp.trim());
        if (verified) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("pendingUsername");
                session.removeAttribute("pendingEmail");
            }
            req.setAttribute("message", "Kích hoạt tài khoản thành công! Bạn có thể đăng nhập ngay bây giờ.");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("alert", "Mã xác thực OTP không chính xác hoặc đã hết hạn!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
        }
    }
}
