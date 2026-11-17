package controller;

import dao.BankAccountDAO;
import dao.VendorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BankAccount;
import model.Vendor;
import java.io.IOException;

public class VendorProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int vendorId = (Integer) request.getSession().getAttribute("vendorId");
            Vendor vendor = new VendorDAO().getVendorById(vendorId);
            if (vendor == null) {
                throw new ServletException("No vendor found for the logged-in vendor ID.");
            }

            BankAccount bankAccount = vendor.getBankAccountId() > 0
                    ? new BankAccountDAO().getById(vendor.getBankAccountId())
                    : null;
            request.setAttribute("vendorProfile", vendor);
            request.setAttribute("vendorBankAccount", bankAccount);
            request.getRequestDispatcher("/vendorProfile.jsp").forward(request, response);
        } catch (ServletException e) {
            throw e;
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
