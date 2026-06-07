package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Hotel;
import model.Room;
import java.io.IOException;
import java.util.List;

@WebServlet("/SearchController")
public class SearchController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        // 1. HÀNH ĐỘNG MẶC ĐỊNH HOẶC TÌM KIẾM KHÁCH SẠN
        if (action == null || action.equals("searchHotel")) {
            String destination = request.getParameter("destination");
            String dateRange = request.getParameter("dateRange");
            String guestsRooms = request.getParameter("guestsRooms");

            List<Hotel> hotels = dao.searchHotelsByArea(destination);

            request.setAttribute("hotels", hotels);
            request.setAttribute("destination", destination);
            request.setAttribute("dateRange", dateRange);
            request.setAttribute("guestsRooms", guestsRooms);

            request.getRequestDispatcher("hotel-list.jsp").forward(request, response);

        } else if (action.equals("viewRooms")) {
            // 2. HÀNH ĐỘNG: Xem chi tiết danh sách phòng trống khi bấm từ Hotel List
            int hotelId = Integer.parseInt(request.getParameter("hotelId"));
            String dateRange = request.getParameter("dateRange");
            String guestsRooms = request.getParameter("guestsRooms");
            String destination = request.getParameter("destination");

            // Lấy thông tin khách sạn gửi qua làm tiêu đề & sidebar theo layout ban đầu
            Hotel selectedHotel = dao.getHotelById(hotelId);
            request.setAttribute("selectedHotel", selectedHotel);

            // Phân tích dữ liệu ngày tháng
            String checkIn = "2026-06-01";
            String checkOut = "2026-06-05";
            if (dateRange != null && dateRange.contains("-")) {
                // FIX LỖI 1: Dùng regex \\s*-\\s* để cắt sạch khoảng trống thừa, chống lỗi URL mã hóa
                String[] dates = dateRange.split("\\s*-\\s*");
                if (dates.length == 2) {
                    checkIn = convertDateFormat(dates[0].trim());
                    checkOut = convertDateFormat(dates[1].trim());
                }
            }

            // TÁCH TIÊU CHÍ KHÁCH ĐOẠN CHUẨN
            int reqAdults = 2;
            int reqChildren = 0;
            if (guestsRooms != null) {
                try {
                    String lowerGuests = guestsRooms.toLowerCase();
                    if (lowerGuests.contains("người lớn")) {
                        String adultPart = lowerGuests.split("người lớn")[0];
                        String rawAdults = adultPart.replaceAll("[^0-9]", "").trim();
                        if (!rawAdults.isEmpty()) reqAdults = Integer.parseInt(rawAdults);
                    }
                    // FIX LỖI 2: Cắt chuẩn từ chữ "trẻ em" ngược về trước để lấy đúng số lượng trẻ em
                    if (lowerGuests.contains("trẻ em")) {
                        String childPart = lowerGuests.split("trẻ em")[0];
                        // Lấy đoạn chuỗi nằm giữa "người lớn" và "trẻ em"
                        if (childPart.contains("người lớn")) {
                            childPart = childPart.split("người lớn")[1];
                        }
                        String rawChildren = childPart.replaceAll("[^0-9]", "").trim();
                        if (!rawChildren.isEmpty()) reqChildren = Integer.parseInt(rawChildren);
                    }
                } catch (Exception e) {
                    reqAdults = 2;
                    reqChildren = 0;
                }
            }

            // ĐÃ ĐỒNG BỘ: Gọi thẳng hàm lấy danh sách phòng thật từ DB
            List<Room> rooms = dao.getAvailableRooms(hotelId, checkIn, checkOut);

            // Đẩy toàn bộ thuộc tính sang room_list.jsp
            request.setAttribute("rooms", rooms);
            request.setAttribute("destination", destination);
            request.setAttribute("dateRange", dateRange);
            request.setAttribute("guestsRooms", guestsRooms);

            // Điều hướng về file room_list.jsp
            request.getRequestDispatcher("room_list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String convertDateFormat(String dateStr) {
        try {
            if (dateStr.contains("/")) {
                String[] tokens = dateStr.split("/");
                if (tokens.length == 3) {
                    return tokens[2].trim() + "-" + tokens[1].trim() + "-" + tokens[0].trim();
                }
            }
        } catch (Exception e) {}
        return dateStr;
    }
}