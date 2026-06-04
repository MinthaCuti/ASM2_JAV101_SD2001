package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RegisterController", value = "/RegisterController")
public class RegisterController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String countryCode = request.getParameter("country");
        String phoneNumber = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        UserDAO userDAO = new UserDAO();
        boolean isSuccess = userDAO.registerUser(firstName, lastName, countryCode, phoneNumber, password);

        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            // Nếu không khớp, quay về trang signin kèm mã lỗi riêng biệt để hiển thị thông báo
            response.sendRedirect("signup.jsp?error=passwordMismatch");
            return; // Dừng xử lý luôn
        }

        if (isSuccess) {
            // Đăng ký xong tự nạp session chào mừng rồi nhảy vào trang chủ luôn
            HttpSession session = request.getSession();
            session.setAttribute("userPhone", phoneNumber);
            response.sendRedirect("home.jsp");
        } else {
            // Thất bại (Trùng số điện thoại) quay lại báo lỗi đỏ
            response.sendRedirect("signup.jsp?error=1");
        }
    }
}