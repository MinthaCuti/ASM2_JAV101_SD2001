package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/home.jsp", "/booking.jsp", "/SearchController", "/ProfileServlet", "/userdetail.jsp","/profile.jsp", "/update.jsp", "/BookingController", "/CommissionController", "/UserdetailController", "/accountmanagement.jsp", "/commission.jsp", "/quan-ly-hoa-hong", "/booking.jsp", "/BookingController", "/payment.jsp", "/PaymentController"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Lấy session hiện tại ra kiểm tra (không tạo session mới nếu chưa có)
        HttpSession session = httpRequest.getSession(false);

        // Kiểm tra xem người dùng đã đăng nhập chưa
        boolean isLoggedIn = (session != null && session.getAttribute("userPhone") != null);

        if (isLoggedIn) {
            // Đã login rồi -> Cho phép đi tiếp đến trang họ muốn nhen!
            chain.doFilter(request, response);
        } else {
            // Chưa login (hoặc paste link sang trình duyệt mới) -> Bắt quay xe về trang login ngay lập tức!
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
        }
    }

    @Override
    public void destroy() {
        // Phá hủy filter khi stop server
    }
}