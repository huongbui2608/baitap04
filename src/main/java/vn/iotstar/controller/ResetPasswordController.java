package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String resetUser = null;
        if (session != null && session.getAttribute("resetUser") != null) {
            resetUser = (String) session.getAttribute("resetUser");
        }
        req.setAttribute("resetUser", resetUser);
        req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String emailOrUsername = req.getParameter("emailOrUsername");
        String otp = req.getParameter("otp");
        String newPassword = req.getParameter("newPassword");
        String rePassword = req.getParameter("rePassword");

        // VALIDATION SERVER-SIDE (Yêu cầu 2)
        if (emailOrUsername == null || emailOrUsername.trim().isEmpty()
                || otp == null || otp.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng điền đầy đủ tất cả các trường!");
            req.setAttribute("resetUser", emailOrUsername);
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!otp.trim().matches("^[0-9]{6}$")) {
            req.setAttribute("alert", "Mã xác thực OTP phải là dãy 6 chữ số!");
            req.setAttribute("resetUser", emailOrUsername);
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        if (newPassword.length() < 6) {
            req.setAttribute("alert", "Mật khẩu mới phải có tối thiểu 6 ký tự!");
            req.setAttribute("resetUser", emailOrUsername);
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(rePassword)) {
            req.setAttribute("alert", "Mật khẩu xác nhận không khớp!");
            req.setAttribute("resetUser", emailOrUsername);
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        boolean reset = userService.resetPassword(emailOrUsername.trim(), otp.trim(), newPassword);
        if (reset) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("resetUser");
            }
            req.setAttribute("message", "Đặt lại mật khẩu thành công! Bạn có thể đăng nhập bằng mật khẩu mới.");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("alert", "Mã xác thực OTP không chính xác hoặc đã hết hạn!");
            req.setAttribute("resetUser", emailOrUsername);
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
        }
    }
}
