package controller;

import model.User;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginController", value = "/LoginController")
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        // Kiểm tra xem số điện thoại có tồn tại không
        boolean isPhoneExists = userDAO.checkPhoneExists(phone);
        if (!isPhoneExists) {
            // Nếu không tồn tại, quay lại trang đăng nhập báo lỗi userNotFound
            response.sendRedirect("index.jsp?error=userNotFound");
            return;
        }

        // Nếu số điện thoại có đúng, tiếp tục kiểm tra mật khẩu
        boolean isPasswordCorrect = userDAO.validatePassword(phone, password);
        if (!isPasswordCorrect) {
            // Nếu sai mật khẩu, quay lại trang đăng nhập báo lỗi wrongPassword
            response.sendRedirect("index.jsp?error=wrongPassword");
            return;
        }

        // Đăng nhập thành công -> Tiến hành cấp Session
        HttpSession session = request.getSession();
        session.setAttribute("userPhone", phone);

        // Lưu lại UserID của người dùng
        int userId = userDAO.getUserIdByPhone(phone); // Cậu viết thêm hàm lấy ID này trong UserDAO nhé
        session.setAttribute("userId", userId);

        // Lấy trực tiếp FirstName từ hàm trong UserDAO để hiển thị câu chào mừng
        String firstName = userDAO.getFirstNameByPhone(phone);
        session.setAttribute("firstName", firstName);

        // Lấy trực tiếp Email trong UserDAO
        String email = userDAO.getEmailByPhone(phone);
        session.setAttribute("userEmail", email);


        String role = userDAO.getRoleByPhone(phone);
        if (role != null) {
            role = role.trim().toLowerCase(); // Xóa sạch khoảng trắng thừa và chuyển hết thành chữ thường
        }
        session.setAttribute("userRole", role);

        response.sendRedirect("home.jsp");
    }
}