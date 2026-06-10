package controller;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Random;

@WebServlet("/FinalizeBookingController")
public class FinalizeBookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Cấu hình UTF-8 nhận dữ liệu Tiếng Việt không bị lỗi font
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 2. Hứng phương thức thanh toán từ giao diện gửi lên
        String paymentMethod = request.getParameter("paymentMethod");

        // [MẸO BẢO VỆ]: Nếu Request bị thiếu, thử tìm trong Session xem trước đó có lưu không
        if (paymentMethod == null && session.getAttribute("paymentMethod") != null) {
            paymentMethod = session.getAttribute("paymentMethod").toString();
        }

        // 🔍 DÒNG LỆNH KIỂM TRA (DEBUG): Cậu hãy nhìn xuống tab Console của NetBeans/Eclipse/IntelliJ khi bấm đặt phòng nhé!
        System.out.println("=================================================");
        System.out.println("👉 PHƯƠNG THỨC THANH TOÁN ĐANG NHẬN ĐƯỢC: [" + paymentMethod + "]");
        System.out.println("=================================================");

        // Mặc định ban đầu là Đã thanh toán (dành cho chuyển khoản, quét QR)
        String bookingStatus = "Đã thanh toán";

        // ==============================================================================
        // BỘ LỌC AN TOÀN MỞ RỘNG: Quét sạch các trường hợp giá trị có thể xảy ra
        // ==============================================================================
        if (paymentMethod != null) {
            String methodLower = paymentMethod.toLowerCase().trim();
            if (methodLower.contains("hotel") ||
                    methodLower.contains("khach_san") ||
                    methodLower.contains("khách sạn") ||
                    methodLower.contains("cash") ||       // Phòng hờ value="cash"
                    methodLower.contains("offline") ||    // Phòng hờ value="offline"
                    methodLower.contains("direct")) {     // Phòng hờ value="direct"

                bookingStatus = "Chờ thanh toán";
            }
        }

        // Lưu trạng thái chuẩn vào Session để file SendEmailController lôi ra dùng
        session.setAttribute("paymentStatus", bookingStatus);

        // Hứng các dữ liệu khác từ Form hoặc Session phục vụ lưu DB
        String roomIdStr = request.getParameter("roomId");
        String customerName = request.getParameter("customerName");
        String hotelName = request.getParameter("hotelName");
        String roomName = request.getParameter("roomName");
        String totalNights = request.getParameter("totalNights");
        String finalPriceStr = request.getParameter("finalPrice");
        String dateRange = request.getParameter("dateRange");

        if (roomIdStr == null) roomIdStr = (String) session.getAttribute("roomId");
        if (customerName == null) customerName = (String) session.getAttribute("customerName");
        if (hotelName == null) hotelName = (String) session.getAttribute("hotelName");
        if (roomName == null) roomName = (String) session.getAttribute("roomName");
        if (totalNights == null && session.getAttribute("totalNights") != null) {
            totalNights = session.getAttribute("totalNights").toString();
        }
        if (finalPriceStr == null && session.getAttribute("finalPrice") != null) {
            finalPriceStr = session.getAttribute("finalPrice").toString();
        }
        if (dateRange == null) dateRange = (String) session.getAttribute("dateRange");

        int roomId = Integer.parseInt(roomIdStr != null ? roomIdStr : "1");
        long finalPrice = Long.parseLong(finalPriceStr != null ? finalPriceStr : "0");

        // Xử lý ngày Check-In / Check-Out
        LocalDate checkInDate = LocalDate.now();
        LocalDate checkOutDate = LocalDate.now().plusDays(1);
        try {
            if (dateRange != null && dateRange.contains(" - ")) {
                String[] dates = dateRange.split(" - ");
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                checkInDate = LocalDate.parse(dates[0].trim(), formatter);
                checkOutDate = LocalDate.parse(dates[1].trim(), formatter);
            }
        } catch (Exception e) {
            System.out.println("Lỗi parse ngày tháng: " + e.getMessage());
        }

        int customerId = 1;

        // Sinh mã booking ngẫu nhiên
        Random rand = new Random();
        int codeSuffix = 100000 + rand.nextInt(900000);
        String bookingId = "VD" + codeSuffix;

        // THỰC HIỆN GỌI DAO LƯU DATABASE
        BookingDAO bookingDAO = new BookingDAO();
        boolean isSaved = bookingDAO.createBookingWithCommission(customerId, roomId, checkInDate, checkOutDate, finalPrice, customerName, bookingId, bookingStatus);

        if (isSaved) {
            request.setAttribute("bookingId", bookingId);
            request.setAttribute("customerName", customerName);
            request.setAttribute("hotelName", hotelName);
            request.setAttribute("roomName", roomName);
            request.setAttribute("totalNights", totalNights);
            request.setAttribute("finalPrice", finalPriceStr);

            session.removeAttribute("roomId");
            request.getRequestDispatcher("booking_success.jsp").forward(request, response);
        } else {
            session.setAttribute("errorMessage", "Hệ thống gặp sự cố khi xử lý đặt phòng. Vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/payment.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}