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
        String hotelName = request.getParameter("hotelName");
        String roomName = request.getParameter("roomName");
        String voucherCode = request.getParameter("voucherCode");

        long basePrice = 1;
        int totalNights = 1;
        int requiredRooms = 1;

        try {
            basePrice = Long.parseLong(request.getParameter("basePrice"));
            totalNights = Integer.parseInt(request.getParameter("totalNights"));
            requiredRooms = Integer.parseInt(request.getParameter("requiredRooms"));
        } catch (Exception e) {
            // Xử lý exception nếu có lỗi parse số
        }

// Công thức chốt sổ
        long rawTotal = basePrice * requiredRooms * totalNights;
        long taxAndFees = (long) (rawTotal * 0.1);
        long priceWithVAT = rawTotal + taxAndFees; // Đây là giá 2.200.000 đ

        long discount = 0;
        // Kiểm tra nếu có mã NEWBIE thì giảm 15% trên giá ĐÃ CÓ VAT
        if (voucherCode != null && voucherCode.equals("NEWBIE")) {
            discount = (long) (priceWithVAT * 0.15);
        }

        long finalPrice = priceWithVAT - discount;

        // 4. Đẩy toàn bộ thuộc tính dữ liệu đóng gói sang Request Scope
        session.setAttribute("roomId", roomId);
        session.setAttribute("dateRange", dateRange != null ? dateRange : "01/06/2026 - 05/06/2026");
        session.setAttribute("customerName", customerName);
        session.setAttribute("customerEmail", customerEmail);
        session.setAttribute("customerPhone", customerPhone);

        session.setAttribute("hotelName", hotelName);
        session.setAttribute("roomName", roomName);
        session.setAttribute("totalNights", totalNights);
        session.setAttribute("requiredRooms", requiredRooms);
        session.setAttribute("voucherCode", voucherCode);

        session.setAttribute("basePrice", basePrice);
        session.setAttribute("rawTotal", rawTotal);
        session.setAttribute("priceWithVAT", priceWithVAT);
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