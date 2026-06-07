package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/PaymentController")
public class PaymentController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Cấu hình giải mã UTF-8 để nhận dữ liệu chuỗi Tiếng Việt không bị lỗi font
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        // 2. Hứng các dữ liệu thông tin cá nhân và cấu hình phòng từ form ẩn trang booking đẩy sang
        String roomId = request.getParameter("roomId");
        String dateRange = request.getParameter("dateRange");
        String customerName = request.getParameter("customerName");
        String customerEmail = request.getParameter("customerEmail");
        String customerPhone = request.getParameter("customerPhone");

        // 3. Logic xử lý tính toán giá tiền & Giả lập thông tin hạng phòng
        String hotelName = "Verdelle Premium Resort & Hotel";
        String roomName = "Phòng Tiêu Chuẩn Luxury";
        long basePrice = 1450000;
        int totalNights = 4;

        if ("1".equals(roomId)) {
            roomName = "Phòng Deluxe Hướng Biển (Deluxe Ocean View)";
            basePrice = 1450000;
        } else if ("2".equals(roomId)) {
            roomName = "Phòng Executive Suite Cao Cấp";
            basePrice = 2890000;
        }

        // Thực hiện tính toán chi phí tài chính chuẩn theo Layout thiết kế
        long rawTotal = basePrice * totalNights;              // Tổng tiền gốc chưa giảm
        long discount = (long) (rawTotal * 0.30);             // Khấu trừ chương trình giảm giá 30%
        long taxAndFees = (long) ((rawTotal - discount) * 0.10); // Thuế VAT và phí dịch vụ tính 10%
        long finalPrice = (rawTotal - discount) + taxAndFees;  // Giá chốt đơn cuối cùng xuất hóa đơn

        // 4. Đẩy toàn bộ thuộc tính dữ liệu đóng gói sang Request Scope
        session.setAttribute("roomId", roomId);
        session.setAttribute("dateRange", dateRange != null ? dateRange : "01/06/2026 - 05/06/2026");
        session.setAttribute("customerName", customerName);
        session.setAttribute("customerEmail", customerEmail);
        session.setAttribute("customerPhone", customerPhone);

        session.setAttribute("hotelName", hotelName);
        session.setAttribute("roomName", roomName);
        session.setAttribute("totalNights", totalNights);
        session.setAttribute("basePrice", basePrice);
        session.setAttribute("rawTotal", rawTotal);
        session.setAttribute("discount", discount);
        session.setAttribute("taxAndFees", taxAndFees);
        session.setAttribute("finalPrice", finalPrice); // Giá tiền quyết định hiển thị ở đây

        // 5. Chuyển tiếp luồng giao diện xử lý (Forward) sang hiển thị tại payment.jsp
        request.getRequestDispatcher("payment.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Phòng hờ trường hợp người dùng reload trang bằng tay (F5) thì tự động chuyển hướng về trang chủ
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}