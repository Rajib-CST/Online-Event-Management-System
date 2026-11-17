package filter;

import util.AdminPaths;


import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/** Protects all ADMIN pages using a completely separate session flag (adminLoggedIn). */
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI().substring(request.getContextPath().length());

        if (!AdminPaths.isAdminPath(path)) {
            // Not an admin path at all - not this filter's concern.
            chain.doFilter(req, res);
            return;
        }

        if (AdminPaths.isAdminPublicPath(path)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        boolean adminLoggedIn = (session != null && Boolean.TRUE.equals(session.getAttribute("adminLoggedIn")));

        if (adminLoggedIn) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
        }
    }

    @Override
    public void destroy() {}
}
