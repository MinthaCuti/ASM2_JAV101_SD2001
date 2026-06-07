package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/CheckPaymentStatusController")
public class CheckPaymentStatusController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Cấu hình trả về chuẩn JSON cho JavaScript
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 2. Lấy mã phòng từ request gửi lên
        String roomId = request.getParameter("roomId");

        // 3. Đọc trạng thái từ bộ nhớ chung (Application Scope)
        // Đây chính là biến mà FakeBankController (trên điện thoại) sẽ set thành TRUE khi bấm nút
        Boolean isPaid = (Boolean) getServletContext().getAttribute("payment_status_" + roomId);

        // 4. Nếu chưa có ai bấm nút trên điện thoại thì biến này sẽ là null -> gán bằng false
        if (isPaid == null) {
            isPaid = false;
        }

        // 5. CHỐT CHẶN DEMO: Nếu đã thanh toán thành công (true), xóa ngay trạng thái cũ trong bộ nhớ
        // để khi reload hoặc làm lượt đặt mới không bị nhận dữ liệu rác cũ (gây tự động cho qua)
        if (isPaid == true) {
            getServletContext().removeAttribute("payment_status_" + roomId);
        }

        // 6. Trả kết quả về cho giao diện web (true thì nút mở xanh, false thì đứng đợi tiếp)
        response.getWriter().write("{\"isPaid\": " + isPaid + "}");
    }
}