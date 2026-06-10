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

        // 1. TÌM KIẾM KHÁCH SẠN
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

        } else if ("viewRooms".equals(action)) {
            try {
                String hotelIdParam = request.getParameter("hotelId");
                if (hotelIdParam == null || hotelIdParam.isEmpty()) {
                    throw new Exception("Thiếu mã khách sạn (hotelId)");
                }
                int hotelId = Integer.parseInt(hotelIdParam);
                String dateRange = request.getParameter("dateRange");
                String guestsRooms = request.getParameter("guestsRooms");
                String destination = request.getParameter("destination");

                Hotel selectedHotel = dao.getHotelById(hotelId);
                if (selectedHotel == null) {
                    throw new Exception("Không tìm thấy khách sạn với ID: " + hotelId);
                }
                request.setAttribute("selectedHotel", selectedHotel);

                // Xử lý ngày tháng an toàn
                String checkIn = "2026-06-01";
                String checkOut = "2026-06-05";
                if (dateRange != null && dateRange.contains("-")) {
                    String[] dates = dateRange.split("\\s*-\\s*");
                    if (dates.length == 2) {
                        checkIn = convertDateFormat(dates[0].trim());
                        checkOut = convertDateFormat(dates[1].trim());
                    }
                }

                // Gọi DAO lấy phòng đã fix lỗi null
                List<Room> rooms = dao.getAvailableRooms(hotelId, checkIn, checkOut);

                request.setAttribute("rooms", rooms);
                request.setAttribute("destination", destination);
                request.setAttribute("dateRange", dateRange);
                request.setAttribute("guestsRooms", guestsRooms);

                request.getRequestDispatcher("room_list.jsp").forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("<h1>Lỗi hệ thống: " + e.getMessage() + "</h1><p>Hãy xem log console IntelliJ.</p>");
            }
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