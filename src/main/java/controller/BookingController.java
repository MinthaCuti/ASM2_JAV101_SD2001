package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/BookingController")
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy tham số từ URL truyền sang
        String roomId = request.getParameter("roomId");
        String roomNameParam = request.getParameter("roomName");
        String priceParam = request.getParameter("price");
        String dateRange = request.getParameter("dateRange");
        String guestsRooms = request.getParameter("guestsRooms");
        String requiredRoomsStr = request.getParameter("requiredRooms");
        String hotelName = request.getParameter("hotelName");
        String hotelStars = request.getParameter("hotelStars");
        String hotelAddress = request.getParameter("hotelAddress");

        // 🌟 THUẬT TOÁN TÍNH SỐ ĐÊM TỪ CHUỖI DATERANGE CỦA HOME.JSP 🌟
        int totalNights = 1;
        if (dateRange != null && !dateRange.isEmpty()) {
            try {
                if (dateRange.contains("ngày)")) {
                    // Cắt nội dung nằm giữa dấu "(" và chữ " ngày)" để lấy đúng số đêm
                    String daysStr = dateRange.substring(dateRange.indexOf("(") + 1, dateRange.indexOf(" ngày)"));
                    totalNights = Integer.parseInt(daysStr.trim());
                } else if (dateRange.contains("-")) {
                    // Backup: Tính thủ công nếu chuỗi gốc chỉ có định dạng "DD/MM/YYYY - DD/MM/YYYY"
                    String[] dates = dateRange.split("-");
                    java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    java.time.LocalDate d1 = java.time.LocalDate.parse(dates[0].trim(), formatter);
                    java.time.LocalDate d2 = java.time.LocalDate.parse(dates[1].trim().split(" ")[0], formatter);
                    totalNights = (int) java.time.temporal.ChronoUnit.DAYS.between(d1, d2);
                }
            } catch (Exception e) {
                totalNights = 1;
            }
        }
        if (totalNights <= 0) totalNights = 1;

// 🌟 ÉP KIỂU SỐ PHÒNG 🌟
        int requiredRooms = 1;

// 1. Ưu tiên lấy từ requiredRoomsStr trước
        if (requiredRoomsStr != null && !requiredRoomsStr.isEmpty()) {
            try {
                requiredRooms = Integer.parseInt(requiredRoomsStr.trim());
            } catch (Exception e) {
                System.out.println("Lỗi ép kiểu requiredRoomsStr: " + e.getMessage());
            }
        }

// 2. Cứu cánh: Lấy từ guestsRooms bằng Regex nếu requiredRooms vẫn là 1
        if (requiredRooms == 1 && guestsRooms != null && !guestsRooms.isEmpty()) {
            try {
                String lowerGuests = guestsRooms.toLowerCase();
                // Dùng Regex túm chính xác con số đứng trước cụm từ "phòng"
                // Ví dụ: "4 khách, 2 phòng" -> Matcher sẽ bắt đúng số "2"
                java.util.regex.Matcher m = java.util.regex.Pattern.compile("(\\d+)\\s*phòng").matcher(lowerGuests);
                if (m.find()) {
                    requiredRooms = Integer.parseInt(m.group(1));
                }
            } catch (Exception e) {
                System.out.println("Lỗi parse số phòng từ guestsRooms: " + e.getMessage());
            }
        }

// 🌟 TÍNH TOÁN GIÁ TIỀN CHUẨN XÁC: (GIÁ GỐC 1 PHÒNG) * SỐ PHÒNG * SỐ ĐÊM 🌟
        long pricePerNight = 1000000; // Giá mặc định phòng hờ

        try {
            if (priceParam != null && !priceParam.isEmpty()) {
                // Cắt bỏ phần thập phân (.0 hoặc .00) từ SQL Server để không bị sai số
                String safePrice = priceParam;
                if (safePrice.contains(".")) {
                    safePrice = safePrice.substring(0, safePrice.indexOf("."));
                }
                // Lọc sạch ký tự lạ chữ "đ" rồi mới ép sang Long
                pricePerNight = Long.parseLong(safePrice.replaceAll("[^0-9]", ""));
            }
        } catch (Exception e) {
            pricePerNight = 1000000;
        }

// Tính tổng chi phí chốt đơn
        long finalTotalPrice = pricePerNight * requiredRooms * totalNights;

    // 2. Cập nhật dữ liệu vào Map để đẩy sang JSP
        Map<String, String> roomInfo = new HashMap<>();
        roomInfo.put("roomId", roomId != null ? roomId : "0");
        roomInfo.put("roomName", (roomNameParam != null && !roomNameParam.isEmpty()) ? roomNameParam : "Phòng Tiêu Chuẩn");
        roomInfo.put("basePrice", String.valueOf(pricePerNight)); // Giá gốc 1 đêm từ DB
        roomInfo.put("price", String.valueOf(finalTotalPrice));   // Tổng tiền tạm tính

        roomInfo.put("hotelName", hotelName != null ? hotelName : "Verdelle Hotel");
        roomInfo.put("hotelStars", hotelStars != null ? hotelStars : "5");
        roomInfo.put("hotelAddress", hotelAddress != null ? hotelAddress : "Việt Nam");
        roomInfo.put("area", "35");
        roomInfo.put("bed", "Giường tiêu chuẩn theo hạng phòng");
        roomInfo.put("image", "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800");

    // 3. Đẩy thêm các thuộc tính lên Request Scope
        request.setAttribute("selectedRoom", roomInfo);
        request.setAttribute("totalNights", totalNights);
        request.setAttribute("requiredRooms", requiredRooms);
        request.setAttribute("dateRange", dateRange);
        request.setAttribute("guestsRooms", guestsRooms);

    // 4. Chuyển tiếp dữ liệu sang trang booking.jsp ẩn
        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cấu hình tiếp nhận luồng dữ liệu POST từ room_list.jsp và chuyển giao cho doGet xử lý chung một logic
        doGet(request, response);
    }
}