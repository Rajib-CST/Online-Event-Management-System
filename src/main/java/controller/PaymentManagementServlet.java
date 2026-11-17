package controller;

import dao.PaymentDAO;
import dao.RefundDAO;
import dao.VendorDAO;
import model.Payment;
import model.Vendor;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Admin: View payments/transaction history, refunds ledger, per-vendor gross/deductions/net earnings, and platform commission. */
public class PaymentManagementServlet extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final VendorDAO vendorDAO = new VendorDAO();
    private final RefundDAO refundDAO = new RefundDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Payment> payments = paymentDAO.getAllPayments();
            List<Vendor> vendors = vendorDAO.getAllVendors();
            List<RefundDAO.RefundRecord> refunds = refundDAO.getAllRefunds();

            Map<Integer, BigDecimal> vendorGrossEarnings = new HashMap<>();
            Map<Integer, BigDecimal> vendorDeductions = new HashMap<>();
            Map<Integer, BigDecimal> vendorEarnings = new HashMap<>(); // Net earnings

            for (Vendor v : vendors) {
                int vid = v.getVendorId();
                BigDecimal gross = paymentDAO.getTotalVendorGrossEarnings(vid);
                BigDecimal deduction = refundDAO.getTotalVendorDeductions(vid);
                BigDecimal net = gross.subtract(deduction);
                if (net.compareTo(BigDecimal.ZERO) < 0) {
                    net = BigDecimal.ZERO;
                }
                vendorGrossEarnings.put(vid, gross);
                vendorDeductions.put(vid, deduction);
                vendorEarnings.put(vid, net);
            }

            BigDecimal totalGrossVolume = paymentDAO.getTotalGrossVolume();
            BigDecimal totalRefundsIssued = refundDAO.getTotalCustomerRefunds();
            BigDecimal netPlatformVolume = totalGrossVolume.subtract(totalRefundsIssued);
            BigDecimal totalAdminCommission = paymentDAO.getTotalAdminCommission();
            BigDecimal totalVendorGross = paymentDAO.getTotalVendorGrossEarningsAll();
            BigDecimal totalVendorDeductions = refundDAO.getTotalVendorDeductions();
            BigDecimal totalVendorNet = totalVendorGross.subtract(totalVendorDeductions);
            if (totalVendorNet.compareTo(BigDecimal.ZERO) < 0) {
                totalVendorNet = BigDecimal.ZERO;
            }

            request.setAttribute("payments", payments);
            request.setAttribute("vendors", vendors);
            request.setAttribute("refunds", refunds);

            request.setAttribute("vendorGrossEarnings", vendorGrossEarnings);
            request.setAttribute("vendorDeductions", vendorDeductions);
            request.setAttribute("vendorEarnings", vendorEarnings);

            request.setAttribute("totalGrossVolume", totalGrossVolume);
            request.setAttribute("totalRefundsIssued", totalRefundsIssued);
            request.setAttribute("netPlatformVolume", netPlatformVolume);
            request.setAttribute("totalAdminCommission", totalAdminCommission);
            request.setAttribute("totalVendorGross", totalVendorGross);
            request.setAttribute("totalVendorDeductions", totalVendorDeductions);
            request.setAttribute("totalVendorNet", totalVendorNet);

            request.getRequestDispatcher("/managePayments.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while loading payments.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
