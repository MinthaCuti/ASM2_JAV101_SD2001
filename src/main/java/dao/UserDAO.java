package dao;

import Utils.JpaUtils;
import context.DBConnect;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import model.Hotel;
import model.Room;
import model.User;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // 1. Thực hiện chèn tài khoản mới khi Đăng ký
    public boolean registerUser(String firstName, String lastName, String email, String countryCode, String phoneNumber, String password) {
        String query = "INSERT INTO Users (FirstName, LastName, Email, CountryCode, PhoneNumber, Password, Role, IsActive) VALUES (?, ?, ?, ?, ?, ?, 'Customer', 1)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, countryCode);
            ps.setString(5, phoneNumber);
            ps.setString(6, password);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Kiểm tra tài khoản tồn tại khi Đăng nhập
    public boolean checkLogin(String phoneNumber) {
        String query = "SELECT * FROM Users WHERE PhoneNumber = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, phoneNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Hàm tìm kiếm khách sạn theo khu vực/thành phố
    public List<Hotel> searchHotelsByArea(String keyword) {
        List<Hotel> list = new ArrayList<>();
        String query = "SELECT h.HotelID, h.HotelName, h.City, h.Address, h.StarRating, " +
                "ISNULL(MIN(r.Price), 0) AS MinPrice " +
                "FROM Hotels h " +
                "LEFT JOIN Rooms r ON h.HotelID = r.HotelID " +
                "WHERE h.City LIKE ? OR h.HotelName LIKE ? " +
                "GROUP BY h.HotelID, h.HotelName, h.City, h.Address, h.StarRating";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Hotel hotel = new Hotel();
                    hotel.setId(rs.getInt("HotelID"));
                    hotel.setName(rs.getString("HotelName"));
                    hotel.setCity(rs.getString("City"));
                    hotel.setAddress(rs.getString("Address"));
                    hotel.setStars(rs.getInt("StarRating"));
                    hotel.setMinPrice(rs.getDouble("MinPrice"));
                    list.add(hotel);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Hàm lấy danh sách phòng trống bọc try-catch chống sai tên cột RoomName từ DB
    public List<Room> getAvailableRooms(int hotelId, String checkIn, String checkOut) {
        List<Room> list = new ArrayList<>();

        String query = "SELECT * FROM Rooms WHERE HotelID = ? AND RoomID NOT IN (" +
                "    SELECT RoomID FROM Bookings " +
                "    WHERE BookingStatus = 'Success' " +
                "    AND RoomID IS NOT NULL " +
                "    AND (? < CheckOutDate AND ? > CheckInDate)" +
                ")";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, hotelId);

            try {
                ps.setDate(2, java.sql.Date.valueOf(checkIn));
                ps.setDate(3, java.sql.Date.valueOf(checkOut));
            } catch (Exception eDate) {
                ps.setDate(2, java.sql.Date.valueOf("2026-06-01"));
                ps.setDate(3, java.sql.Date.valueOf("2026-06-05"));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room r = new Room();

                    int roomIdFromDB = rs.getInt("RoomID");
                    r.setId(roomIdFromDB);
                    r.setRoomId(roomIdFromDB);
                    r.setHotelId(rs.getInt("HotelID"));
                    r.setPrice(rs.getDouble("Price")); // Lấy giá chuẩn từ DB

                    // Đọc cột RoomType từ SQL của Mint làm tên hiển thị
                    String roomTypeFromDB = "Phòng Tiêu Chuẩn";
                    try {
                        if (rs.getNString("RoomType") != null) {
                            roomTypeFromDB = rs.getNString("RoomType");
                        }
                    } catch (Exception eName) {
                        try {
                            roomTypeFromDB = rs.getNString("RoomName");
                        } catch (Exception eName2) {}
                    }
                    r.setRoomName(roomTypeFromDB);
                    r.setRoomTypeName(roomTypeFromDB);

                    // BẢO VỆ: Nếu DB chưa có cột MaxAdults thì mặc định là 2
                    try {
                        r.setMaxAdults(rs.getInt("MaxAdults"));
                    } catch (Exception e) {
                        r.setMaxAdults(2);
                    }

                    // BẢO VỆ: Nếu DB chưa có cột MaxChildren thì mặc định là 1
                    try {
                        r.setMaxChildren(rs.getInt("MaxChildren"));
                    } catch (Exception e) {
                        r.setMaxChildren(1);
                    }

                    // BẢO VỆ: Nếu DB chưa có cột Area thì mặc định là 30m²
                    try {
                        r.setArea(rs.getInt("Area"));
                    } catch (Exception e) {
                        r.setArea(30);
                    }

                    // BẢO VỆ: Nếu DB chưa có cột Description
                    try {
                        r.setDescription(rs.getString("Description"));
                    } catch (Exception e) {
                        r.setDescription("Phòng nghỉ rộng rãi, đầy đủ tiện nghi, mang lại cảm giác ấm cúng.");
                    }

                    // BẢO VỆ: Nếu DB chưa có cột Image thì tự lấy ảnh ngẫu nhiên tương ứng với ID phòng cho đẹp mắt
                    try {
                        String img = rs.getString("Image");
                        r.setImage(img != null && !img.isEmpty() ? img : "https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=500");
                    } catch (Exception e) {
                        // Tạo ảnh thay đổi theo ID phòng cho sinh động sinh viên
                        if (roomIdFromDB % 2 == 0) {
                            r.setImage("https://images.unsplash.com/photo-1590490360182-c33d57733427?w=500");
                        } else {
                            r.setImage("https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=500");
                        }
                    }

                    list.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 5. Hàm lấy thông tin một khách sạn cụ thể
    public model.Hotel getHotelById(int hotelId) {
        model.Hotel hotel = null;
        String sql = "SELECT h.HotelID, h.HotelName, h.City, h.Address, h.StarRating, " +
                "ISNULL((SELECT MIN(Price) FROM Rooms WHERE HotelID = h.HotelID), 0) AS MinPrice " +
                "FROM Hotels h WHERE h.HotelID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, hotelId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    hotel = new model.Hotel();
                    hotel.setId(rs.getInt("HotelID"));
                    hotel.setName(rs.getString("HotelName"));
                    hotel.setCity(rs.getString("City"));
                    hotel.setAddress(rs.getString("Address"));
                    hotel.setStars(rs.getInt("StarRating"));
                    hotel.setMinPrice(rs.getDouble("MinPrice"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return hotel;
    }
    public String getFirstNameByPhone(String phoneNumber) {
        String query = "SELECT FirstName FROM Users WHERE PhoneNumber = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, phoneNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("FirstName");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ""; // Trả về chuỗi rỗng nếu không tìm thấy
    }
    public String getRoleByPhone(String phone) {
        String role = "Customer"; // Mặc định nếu có lỗi thì tài khoản là Customer cho an toàn
        String sql = "SELECT Role FROM Users WHERE PhoneNumber = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    role = rs.getString("Role").trim();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return role;
    }

    public String getEmailByPhone(String phone) {
        String email = "";
        // Thay đổi tên bảng và tên cột cho đúng với Database (SQL Server/MySQL) của các bạn nhé
        String query = "SELECT Email FROM Users WHERE PhoneNumber = ?";

        // Đoạn này dùng kết nối DB hiện tại của các bạn (ví dụ dùng Connection, PreparedStatement)
        try {
            // Giả sử các bạn có hàm lấy connection là getConnection() hoặc từ một class DBContext
            java.sql.Connection conn = new context.DBConnect().getConnection(); // Sửa lại cho đúng cách gọi DB của bạn
            java.sql.PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, phone);
            java.sql.ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                email = rs.getString("email");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return email;
    }

    // Kiếm tra xem số điện thoại có tồn tại trong hệ thống không
    public boolean checkPhoneExists(String phoneNumber) {
        String query = "SELECT * FROM Users WHERE PhoneNumber = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, phoneNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu tìm thấy số điện thoại
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    // Kiểm tra xem sự kết hợp giữa Số điện thoại và Mật khẩu có chính xác không
    public boolean validatePassword(String phoneNumber, String password) {
        String query = "SELECT * FROM Users WHERE PhoneNumber = ? AND Password = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, phoneNumber);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu cả tài khoản và mật khẩu đều khớp
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra xem Email Google đăng nhập đã tồn tại trong DB chưa
    public boolean checkEmailExists(String email) {
        String query = "SELECT * FROM Users WHERE Email = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu email đã có tài khoản liên kết
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy số điện thoại tương ứng với Email (Dùng để nạp Session khi tự động đăng nhập)
    public String getPhoneByEmail(String email) {
        String query = "SELECT PhoneNumber FROM Users WHERE Email = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("PhoneNumber");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ""; // Trả về chuỗi rỗng nếu không tìm thấy dữ liệu liên kết
    }


    public List<User> findAll() {
        EntityManager entityManager = JpaUtils.getEntityManager();
        try {
            TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u", User.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            entityManager.close();
        }
    }

    public List<User> getAll() {
        EntityManager entityManager = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.isActive = true";
            return entityManager.createQuery(jpql, User.class).getResultList();
        } finally {
            entityManager.close();
        }
    }

    public User findById(int id){
        EntityManager entityManager = JpaUtils.getEntityManager();
        try {
            String sql = "SELECT u FROM User u WHERE u.id = :id and u.isActive = true";
            TypedQuery<User> query = entityManager.createQuery(sql, User.class);
            query.setParameter("id", id);
            return query.getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            entityManager.close();
        }
        return null;
    }
    public void update(User user) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(user);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
    public void delete(int id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, id);
            if (user != null) {
                // Thay vì xóa hẳn, ta chỉ lật trạng thái hoạt động sang false (vô hiệu hóa)
                user.setIsActive(false);
                em.merge(user); // Lưu cập nhật trạng thái xuống database
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
    }

    // Hàm lấy đầy đủ Object User bằng số điện thoại (Dùng JPA)
    public User getUserByPhone(String phone) {
        jakarta.persistence.EntityManager em = Utils.JpaUtils.getEntityManager();
        try {
            // Câu lệnh JPQL tìm User theo số điện thoại
            String jpql = "SELECT u FROM User u WHERE u.phoneNumber = :phone";
            jakarta.persistence.TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("phone", phone);

            java.util.List<User> list = query.getResultList();
            // Nếu tìm thấy thì trả về phần tử đầu tiên, không thì trả về null
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}