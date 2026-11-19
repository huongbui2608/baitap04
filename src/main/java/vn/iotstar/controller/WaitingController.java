package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.model.User;

import java.io.IOException;

@WebServlet("/waiting")
public class WaitingController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User account = (session != null) ? (User) session.getAttribute("account") : null;

        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        switch (account.getRoleid()) {
            case 1 -> resp.sendRedirect(req.getContextPath() + "/admin/home");
            case 2 -> resp.sendRedirect(req.getContextPath() + "/manager/home");
            default -> resp.sendRedirect(req.getContextPath() + "/home");
        }
    }
}