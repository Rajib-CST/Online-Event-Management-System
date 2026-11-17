package filter;
import util.AdminPaths;
import jakarta.servlet.*;
import jakarta.servlet.http.*; 
import java.io.*; 
public class VendorAuthFilter implements Filter
{
	public void doFilter(ServletRequest q,ServletResponse z,FilterChain c)throws IOException,ServletException{
		HttpServletRequest r=(HttpServletRequest)q;
		HttpServletResponse s=(HttpServletResponse)z;
		String p=r.getRequestURI().substring(r.getContextPath().length());
		if(AdminPaths.isAdminPath(p))
		{
			c.doFilter(q,z);return;
		}
		if((!p.startsWith("/Vendor")||p.equals("/VendorServlet"))&&!p.equals("/vendorDashboard.jsp")&&!p.equals("/vendorItems.jsp")&&!p.equals("/vendorBookings.jsp")&&!p.equals("/vendorProfile.jsp"))
		{
			c.doFilter(q,z);return;
			}
		if(p.equals("/VendorServlet"))
		{c.doFilter(q,z);return;
		}
		if(p.equals("/vendorLogin.jsp")||p.equals("/vendorSignup.jsp")||p.equals("/VendorLoginServlet")||p.equals("/VendorSignupServlet"))
		{c.doFilter(q,z);return;
		}
		HttpSession x=r.getSession(false);
		if(x!=null&&Boolean.TRUE.equals(x.getAttribute("vendorLoggedIn"))&&"VENDOR".equals(x.getAttribute("role")))c.doFilter(q,z);
		else
	s.sendRedirect(r.getContextPath()+"/vendorLogin.jsp");
}
}
