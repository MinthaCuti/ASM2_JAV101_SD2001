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

        // 1. HÀNH ĐỘNG MẶC ĐỊNH: Tìm kiếm danh sách khách sạn theo khu vực
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

            // GIỮ NGUYÊN BỐ CỤC: Lấy thông tin khách sạn gửi qua làm tiêu đề & sidebar theo layout ban đầu
            Hotel selectedHotel = dao.getHotelById(hotelId);
            request.setAttribute("selectedHotel", selectedHotel);

            // Phân tích dữ liệu ngày để đưa vào câu lệnh (Giữ lại để đồng bộ thông tin thanh tìm kiếm)
            String checkIn = "2026-06-01";
            String checkOut = "2026-06-05";
            if (dateRange != null && dateRange.contains(" - ")) {
                String[] dates = dateRange.split(" - ");
                checkIn = convertDateFormat(dates[0].trim());
                checkOut = convertDateFormat(dates[1].trim());
            }

            // TÁCH TIÊU CHÍ KHÁCH (Giữ lại để không làm lệch thông tin form nhập trên layout)
            int reqAdults = 2;
            int reqChildren = 0;
            if (guestsRooms != null) {
                try {
                    String lowerGuests = guestsRooms.toLowerCase();
                    if (lowerGuests.contains("người lớn")) {
                        String rawAdults = lowerGuests.split("người lớn")[0].replaceAll("[^0-9]", "").trim();
                        if (!rawAdults.isEmpty()) reqAdults = Integer.parseInt(rawAdults);
                    }
                    if (lowerGuests.contains("trẻ em")) {
                        String[] parts = lowerGuests.split("người lớn");
                        if (parts.length > 1) {
                            String rawChildren = parts[1].replaceAll("[^0-9]", "").trim();
                            if (!rawChildren.isEmpty()) reqChildren = Integer.parseInt(rawChildren);
                        }
                    }
                } catch (Exception e) {
                    reqAdults = 2;
                    reqChildren = 0;
                }
            }

            // Đồng thời gán danh sách rooms bằng null để giao diện nhận biết trạng thái "Đang cập nhật"
            List<Room> rooms = null;

            // Loại bỏ thuật toán tìm phòng tối ưu vì không dùng dữ liệu phòng từ DB nữa

            // Gửi toàn bộ dữ liệu cấu trúc layout sang tầng hiển thị JSP
            request.setAttribute("rooms", rooms);
            request.setAttribute("dateRange", dateRange);
            request.setAttribute("guestsRooms", guestsRooms);

            // Điều hướng chính xác về file room_list.jsp nằm trong thư mục webapp
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