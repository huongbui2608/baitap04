package vn.iotstar.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import vn.iotstar.model.User;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/manager/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User account = (session != null) ? (User) session.getAttribute("account") : null;

        String path = req.getServletPath();

        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (path.startsWith("/admin") && account.getRoleid() != 1) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }

        if (path.startsWith("/manager") && account.getRoleid() != 2) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }

        chain.doFilter(request, response);
    }
}