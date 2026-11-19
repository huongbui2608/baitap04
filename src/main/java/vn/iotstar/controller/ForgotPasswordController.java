package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;

import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String emailOrUsername = req.getParameter("emailOrUsername");

        // VALIDATION (Yêu cầu 2)
        if (emailOrUsername == null || emailOrUsername.trim().length() < 3) {
            req.setAttribute("alert", "Vui lòng nhập chính xác Email hoặc Tên đăng nhập của bạn (tối thiểu 3 ký tự)!");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        boolean sent = userService.sendForgotPasswordOtp(emailOrUsername.trim());
        if (sent) {
            HttpSession session = req.getSession(true);
            session.setAttribute("resetUser", emailOrUsername.trim());
            resp.sendRedirect(req.getContextPath() + "/reset-password");
        } else {
            req.setAttribute("alert", "Không tìm thấy tài khoản nào khớp với Email hoặc Tên đăng nhập này!");
            req.setAttribute("emailOrUsername", emailOrUsername);
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }
}
