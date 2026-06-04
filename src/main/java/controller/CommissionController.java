package controller;

import dao.CommissionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Commission;

import java.io.IOException;
import java.util.List;

@WebServlet("/quan-ly-hoa-hong")
public class CommissionController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Gọi DAO để lấy dữ liệu thực tế từ Database xuống
        CommissionDAO dao = new CommissionDAO();
        List<Commission> list = dao.getAllCommissions();

        // Logic tự động tính toán các con số tổng hợp dựa trên data thật từ DB
        double totalReceived = 0;
        double totalPending = 0;
        double totalRate = 0;

        for (Commission c : list) {
            if ("Đã thanh toán".equals(c.getStatus())) {
                totalReceived += c.getCommissionAmount();
            } else {
                totalPending += c.getCommissionAmount();
            }
            totalRate += c.getCommissionRate();
        }

        // Tính toán tỷ lệ hoa hồng trung bình dựa trên tổng số dòng dữ liệu trả về
        String avgRateStr = "10%";
        if (!list.isEmpty()) {
            double avgRate = totalRate / list.size();
            avgRateStr = String.format("%.0f%%", avgRate);
        }

        // Đẩy toàn bộ dữ liệu thật sang request attribute
        request.setAttribute("commissionList", list);
        request.setAttribute("totalReceived", totalReceived);
        request.setAttribute("totalPending", totalPending);
        request.setAttribute("avgRate", avgRateStr);

        // Chuyển tiếp (Forward) trực tiếp vào trang JSP bảo mật trong WEB-INF
        request.getRequestDispatcher("/WEB-INF/commission.jsp").forward(request, response);
    }
}