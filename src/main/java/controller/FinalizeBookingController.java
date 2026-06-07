package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Random;

@WebServlet("/FinalizeBookingController")
public class FinalizeBookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Cấu hình UTF-8 nhận dữ liệu Tiếng Việt không bị lỗi font
        request.setCharacterEncoding("UTF-8");

        // 2. Hứng các dữ liệu được Form truyền sang ngầm
        String roomId = request.getParameter("roomId");
        String customerName = request.getParameter("customerName");

        // LẤY THÊM dữ liệu phòng và giá tiền (để trang success không bị hiển thị N/A)
        String hotelName = request.getParameter("hotelName");
        String roomName = request.getParameter("roomName");
        String totalNights = request.getParameter("totalNights");
        String finalPrice = request.getParameter("finalPrice");

        // 3. LOGIC ĐỒ ÁN: Tự động sinh mã Đặt phòng ngẫu nhiên đổ ra giao diện
        // Tạo chuỗi mã dạng VD + 6 số ngẫu nhiên (Ví dụ: VD882911)
        Random rand = new Random();
        int codeSuffix = 100000 + rand.nextInt(900000);
        String bookingId = "VD" + codeSuffix;

        // 4. Đóng gói TOÀN BỘ dữ liệu vào Request để trang thành công hiển thị đầy đủ
        request.setAttribute("bookingId", bookingId);
        request.setAttribute("customerName", customerName);
        request.setAttribute("hotelName", hotelName);
        request.setAttribute("roomName", roomName);
        request.setAttribute("totalNights", totalNights);
        request.setAttribute("finalPrice", finalPrice);

        // 5. CHUYỂN HƯỚNG: Mở trang thông báo thành công lên
        // Đảm bảo file JSP đặt tên chính xác là booking_success.jsp
        request.getRequestDispatcher("booking_success.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu người dùng cố tình vào bằng đường link (GET) thì đá về trang chủ
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}