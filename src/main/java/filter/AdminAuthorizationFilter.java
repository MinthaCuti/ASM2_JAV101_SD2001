package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// Cấu hình các đường dẫn cần bảo vệ (Cậu điền đúng các urlPattern của các Controller quản lý vào đây nhé)
@WebFilter(urlPatterns = {
        "/quanly.jsp",
        "/UserController",
        "/HoaHongController",
        "/admin/*"
})
public class AdminAuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần xử lý khi khởi tạo
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String role = (session != null) ? (String) session.getAttribute("userRole") : null;

        // Cơ chế chặn: Nếu role trống HOẶC là "Customer" (Không có quyền Admin)
        if (role == null || "Customer".equalsIgnoreCase(role)) {
            // Lưu một thông báo lỗi vào session để hiển thị nếu cần
            if (session != null) {
                session.setAttribute("errorMessage", "Bạn không có quyền truy cập vào khu vực quản trị!");
            }
            // Đá bay tài khoản này về lại trang chủ home.jsp
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home.jsp");
            return; // Dừng xử lý tại đây, không cho đi tiếp vào trang quản lý
        }

        // Nếu là Admin hoặc Partner hợp lệ, cho phép đi tiếp đến tài nguyên họ muốn
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Không cần xử lý khi hủy filter
    }
}