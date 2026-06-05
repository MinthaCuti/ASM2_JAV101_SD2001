package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

import java.io.IOException;

@WebServlet(name = "updateController", value = "/update")
public class UpdateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        UserDAO dao = new UserDAO();
        User user = dao.findById(id);

        // Đẩy dữ liệu user tìm thấy sang giao diện cập nhật
        req.setAttribute("user", user);
        req.getRequestDispatcher("/update.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Đảm bảo không bị lỗi font tiếng Việt khi bấm lưu Form
        req.setCharacterEncoding("UTF-8");

        // 1. Lấy dữ liệu từ Form gửi lên theo đúng tên các thẻ input mới
        int id = Integer.parseInt(req.getParameter("id"));
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String email = req.getParameter("email");
        String countryCode = req.getParameter("countryCode");
        String phoneNumber = req.getParameter("phoneNumber");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        UserDAO dao = new UserDAO();
        User user = dao.findById(id);

        if (user != null) {
            // 2. Đổ dữ liệu mới vào đối tượng user
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setCountryCode(countryCode);
            user.setPhoneNumber(phoneNumber);
            user.setPassword(password);
            user.setRole(role);

            // 3. Gọi UserDAO sử dụng JPA merge() để cập nhật xuống SQL Server
            dao.update(user);
        }

        // 4. Cập nhật thành công, điều hướng về lại trang quản lý chính
        resp.sendRedirect(req.getContextPath() + "/quan-ly-tai-khoan");
    }
}