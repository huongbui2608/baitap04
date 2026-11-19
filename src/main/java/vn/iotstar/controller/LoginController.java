package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.model.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;

import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("account") != null) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }

        // Kiểm tra cookie "username"
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("username".equals(c.getName())) {
                    User user = userService.get(c.getValue());
                    if (user != null && user.getActive() == 1) {
                        HttpSession newSession = req.getSession(true);
                        newSession.setAttribute("account", user);
                        resp.sendRedirect(req.getContextPath() + "/waiting");
                        return;
                    }
                }
            }
        }

        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        // VALIDATION SERVER-SIDE CHO FORM LOGIN (Yêu cầu 2)
        if (username == null || username.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập Tên đăng nhập hoặc Email!");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập Mật khẩu!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        if (username.trim().length() < 3) {
            req.setAttribute("alert", "Tên đăng nhập hoặc Email phải có ít nhất 3 ký tự!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        User user = userService.login(username.trim(), password);
        if (user != null) {
            // Kiểm tra trạng thái kích hoạt tài khoản
            if (user.getActive() == 0) {
                req.setAttribute("alert", "Tài khoản của bạn chưa được kích hoạt OTP. Vui lòng kích hoạt tài khoản trước khi đăng nhập!");
                req.setAttribute("pendingUsername", user.getUserName());
                req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("account", user);

            if ("on".equals(remember)) {
                Cookie cookie = new Cookie("username", user.getUserName());
                cookie.setMaxAge(30 * 60); // 30 phút
                cookie.setPath("/");
                resp.addCookie(cookie);
            }

            resp.sendRedirect(req.getContextPath() + "/waiting");
        } else {
            req.setAttribute("alert", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        }
    }
}
