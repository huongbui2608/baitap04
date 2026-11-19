package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.EmailUtil;

import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("account") != null) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }
        req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String repassword = req.getParameter("repassword");

        req.setAttribute("username", username);
        req.setAttribute("fullname", fullname);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);

        // VALIDATION SERVER-SIDE CHO FORM REGISTER (Yêu cầu 2)
        if (username == null || !username.trim().matches("^[a-zA-Z0-9_]{3,30}$")) {
            req.setAttribute("alert", "Tên đăng nhập chỉ được chứa chữ cái, số, dấu gạch dưới và có độ dài từ 3 đến 30 ký tự!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (fullname == null || fullname.trim().length() < 2) {
            req.setAttribute("alert", "Họ và tên không được để trống và phải có ít nhất 2 ký tự!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (email == null || !email.trim().matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            req.setAttribute("alert", "Địa chỉ Email không đúng định dạng hợp lệ!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (phone == null || !phone.trim().matches("^(0|\\+84)[3|5|7|8|9][0-9]{8}$")) {
            req.setAttribute("alert", "Số điện thoại không đúng định dạng di động Việt Nam (10 chữ số)! VD: 0901234567");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (password == null || password.length() < 6) {
            req.setAttribute("alert", "Mật khẩu phải có độ dài tối thiểu từ 6 ký tự trở lên!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(repassword)) {
            req.setAttribute("alert", "Mật khẩu xác nhận nhập lại không khớp!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra trùng username, email, phone trong CSDL
        if (userService.checkExistUsername(username.trim())) {
            req.setAttribute("alert", "Tên đăng nhập '" + username.trim() + "' đã tồn tại trong hệ thống!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (userService.checkExistEmail(email.trim())) {
            req.setAttribute("alert", "Email '" + email.trim() + "' đã được sử dụng bởi tài khoản khác!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (userService.checkExistPhone(phone.trim())) {
            req.setAttribute("alert", "Số điện thoại '" + phone.trim() + "' đã được sử dụng!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Sinh mã OTP 6 số ngẫu nhiên
        String otp = EmailUtil.generateOtp(6);

        boolean success = userService.register(username.trim(), password, email.trim(),
                fullname.trim(), phone.trim(), otp);

        if (success) {
            HttpSession session = req.getSession(true);
            session.setAttribute("pendingUsername", username.trim());
            session.setAttribute("pendingEmail", email.trim());
            resp.sendRedirect(req.getContextPath() + "/verify-otp");
        } else {
            req.setAttribute("alert", "Đăng ký thất bại, vui lòng thử lại sau!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
        }
    }
}
