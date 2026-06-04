package controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User; // Nhớ import đúng Entity User có gắn các Annotation JPA của cậu nhé

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AccountController", urlPatterns = {"/quan-ly-tai-khoan"})
public class AccountController extends HttpServlet {

    private EntityManagerFactory factory;

    @Override
    public void init() throws ServletException {
        factory = Persistence.createEntityManagerFactory("HotelManagement");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        EntityManager em = factory.createEntityManager();
        try {
            // 1. Chức năng Xóa mềm: Nếu có gọi action=delete
            if (action.equals("delete")) {
                int id = Integer.parseInt(request.getParameter("id"));
                em.getTransaction().begin();
                User user = em.find(User.class, id);
                if (user != null) {
                    user.setIsActive(false); // Vô hiệu hóa tài khoản
                    em.merge(user);
                }
                em.getTransaction().commit();
                response.sendRedirect(request.getContextPath() + "/quan-ly-tai-khoan");
                return; // Dừng hàm tại đây, không chạy xuống dưới nữa!
            }

            // 2. Chức năng Edit: Tìm user theo ID và đẩy ngược dữ liệu về Form
            if (action.equals("edit")) {
                int id = Integer.parseInt(request.getParameter("id"));
                User user = em.find(User.class, id);
                request.setAttribute("accountForm", user);
            }

            // 3. Lấy danh sách tài khoản chưa bị xóa mềm (u.isActive = true)
            String jpql = "SELECT u FROM User u WHERE u.isActive = true";
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            List<User> listAccounts = query.getResultList();

            request.setAttribute("list", listAccounts);

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
        request.getRequestDispatcher("/WEB-INF/accountmanagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EntityManager em = factory.createEntityManager();
        request.setCharacterEncoding("UTF-8");

        try {
            String idStr = request.getParameter("id");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String countryCode = request.getParameter("countryCode");
            String phoneNumber = request.getParameter("phoneNumber");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            em.getTransaction().begin();

            // Nếu ID rỗng hoặc bằng 0 -> Chức năng THÊM MỚI (Create)
            if (idStr == null || idStr.trim().isEmpty() || idStr.equals("0")) {
                User newUser = new User();
                newUser.setFirstName(firstName);
                newUser.setLastName(lastName);
                newUser.setCountryCode(countryCode);
                newUser.setPhoneNumber(phoneNumber);
                newUser.setPassword(password);
                newUser.setRole(role);
                newUser.setIsActive(true); // Tài khoản mới mặc định luôn hoạt động ổn định

                em.persist(newUser);
            }
            // Nếu có ID hợp lệ -> Chức năng CẬP NHẬT (Update)
            else {
                int id = Integer.parseInt(idStr);
                User existingUser = em.find(User.class, id);
                if (existingUser != null) {
                    existingUser.setFirstName(firstName);
                    existingUser.setLastName(lastName);
                    existingUser.setCountryCode(countryCode);
                    existingUser.setPhoneNumber(phoneNumber);
                    existingUser.setPassword(password);
                    existingUser.setRole(role);

                    em.merge(existingUser);
                }
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }

        // Thực hiện lưu xong quay về trang danh sách sạch sẽ
        response.sendRedirect(request.getContextPath() + "/quan-ly-tai-khoan");
    }

    @Override
    public void destroy() {
        if (factory != null && factory.isOpen()) {
            factory.close();
        }
    }
}