package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "deleteController", value = "/delete")
public class DeleteController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Lấy ID của user cần xóa từ URL (?id=...)
        int id = Integer.parseInt(req.getParameter("id"));

        // 2. Gọi hàm soft delete từ DAO
        UserDAO dao = new UserDAO();
        dao.delete(id);

        // 3. ĐỒNG BỘ: Chuyển hướng chuẩn xác về router danh sách quản lý tài khoản
        resp.sendRedirect(req.getContextPath() + "/quan-ly-tai-khoan");
    }
}