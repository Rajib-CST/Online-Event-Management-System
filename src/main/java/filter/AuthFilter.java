package filter;

import util.AdminPaths;


import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Protects all CUSTOMER pages. Skips admin paths entirely (delegated to
 * AdminAuthFilter) and a short public allow-list (login/signup/etc).
 */
public class AuthFilter implements Filter {

    private static final String[] PUBLIC_PATHS = {
        "/", "", "/index.jsp", "/login.jsp", "/signup.jsp",
        "/forgotPassword.jsp", "/resetPassword.jsp",
        "/LoginServlet", "/SignupServlet",
        "/ForgotPasswordServlet", "/ResetPasswordServlet",
        "/css/", "/js/", "/error.jsp"
    };

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI().substring(request.getContextPath().length());
        if (path.startsWith("/Vendor") || path.equals("/vendorLogin.jsp") || path.equals("/vendorSignup.jsp") || path.equals("/vendorDashboard.jsp") || path.equals("/vendorItems.jsp") || path.equals("/vendorBookings.jsp") || path.equals("/vendorProfile.jsp") || path.equals("/CancellationServlet")) { chain.doFilter(req,res); return; }

        // Admin paths are handled exclusively by AdminAuthFilter.
        if (AdminPaths.isAdminPath(path)) {
            chain.doFilter(req, res);
            return;
        }

        if (isPublicPath(path)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        boolean loggedIn = (session != null && Boolean.TRUE.equals(session.getAttribute("loggedIn")));

        if (loggedIn) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    private boolean isPublicPath(String path) {
        for (String p : PUBLIC_PATHS) {
            if (path.equals(p) || (p.endsWith("/") && path.startsWith(p))) return true;
        }
        return false;
    }

    @Override
    public void destroy() {}
}
