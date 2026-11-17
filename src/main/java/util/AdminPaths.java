package util;

import java.util.Arrays;
import java.util.List;

/**
 * Single source of truth for which servlet paths belong to the admin section.
 * Shared by AuthFilter (must SKIP these) and AdminAuthFilter (must PROTECT
 * these). An earlier substring check (path.contains("admin")) failed to
 * recognize servlets like VendorManagementServlet as admin paths - this
 * exact-match list replaces it.
 */
public class AdminPaths {

    private static final List<String> ADMIN_PATHS = Arrays.asList(
        "/adminDashboard.jsp",
        "/manageVendors.jsp",
        "/manageItems.jsp",
        "/manageBookings.jsp",
        "/managePayments.jsp",
        "/AdminLoginServlet",
        "/AdminLogoutServlet",
        "/VendorManagementServlet",
        "/ItemManagementServlet",
        "/BookingManagementServlet",
        "/PaymentManagementServlet"
    );

    private static final List<String> ADMIN_PUBLIC_PATHS = Arrays.asList(
        "/adminLogin.jsp",
        "/AdminLoginServlet"
    );

    private AdminPaths() {}

    public static boolean isAdminPath(String path) {
        return ADMIN_PATHS.contains(path) || ADMIN_PUBLIC_PATHS.contains(path);
    }

    /** Admin paths that must be reachable WITHOUT an admin session (the login page/servlet itself). */
    public static boolean isAdminPublicPath(String path) {
        return ADMIN_PUBLIC_PATHS.contains(path);
    }
}
