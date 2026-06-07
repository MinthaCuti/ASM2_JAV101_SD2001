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
        String requiredRooms = request.getParameter("requiredRooms");

        String hotelName = request.getParameter("hotelName");
        String hotelStars = request.getParameter("hotelStars");
        String hotelAddress = request.getParameter("hotelAddress");

        // 2. Tạo dữ liệu giả lập cho phòng (Match theo hình thiết kế của cậu)
        Map<String, String> roomInfo = new HashMap<>();

        // Đồng bộ thông tin khách sạn: Ưu tiên lấy từ luồng dữ liệu thật, nếu trống mới fallback về mặc định
        roomInfo.put("hotelName", (hotelName != null && !hotelName.isEmpty()) ? hotelName : "Verdelle Premium Resort & Hotel");
        roomInfo.put("hotelStars", (hotelStars != null && !hotelStars.isEmpty()) ? hotelStars : "5");
        roomInfo.put("hotelAddress", (hotelAddress != null && !hotelAddress.isEmpty()) ? hotelAddress : "Khu phố 4, Phường Hàm Tiến, Thành phố Phan Thiết, Bình Thuận");

        // ĐÃ FIX: Bỏ hoàn toàn if-else cứng. Bốc trực tiếp dữ liệu từ room_list.jsp đẩy sang để nhận mọi RoomID từ DB
        roomInfo.put("roomId", roomId != null ? roomId : "0");
        roomInfo.put("roomName", (roomNameParam != null && !roomNameParam.isEmpty()) ? roomNameParam : "Phòng Tiêu Chuẩn");
        roomInfo.put("price", (priceParam != null && !priceParam.isEmpty()) ? priceParam : "1000000");

        // Các thuộc tính phụ phụ thuộc vào loại phòng, nếu có truyền thì lấy, không thì gán mặc định an toàn
        roomInfo.put("area", "35");
        roomInfo.put("bed", "Giường tiêu chuẩn theo hạng phòng");
        roomInfo.put("image", "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800");

        // 3. Đẩy đối tượng Map và dateRange vào request scope
        request.setAttribute("selectedRoom", roomInfo);
        request.setAttribute("dateRange", dateRange);
        request.setAttribute("guestsRooms", guestsRooms);
        request.setAttribute("requiredRooms", requiredRooms);

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