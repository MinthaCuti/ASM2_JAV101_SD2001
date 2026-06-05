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
            ps.setDate(2, Date.valueOf(checkIn));
            ps.setDate(3, Date.valueOf(checkOut));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room r = new Room();

                    int roomIdFromDB = rs.getInt("RoomID");
                    r.setId(roomIdFromDB);
                    r.setRoomId(roomIdFromDB);
                    r.setHotelId(rs.getInt("HotelID"));

                    // BỌC BẢO VỆ CỘT TÊN PHÒNG: Thử lấy RoomName, nếu lỗi thì thử lấy cột khác hoặc gán mặc định
                    String finalRoomName = "Phòng Deluxe Hướng Biển";
                    try {
                        finalRoomName = rs.getNString("RoomName");
                    } catch (Exception e1) {
                        try {
                            finalRoomName = rs.getNString("RoomType"); // Thử cột dự phòng 1
                        } catch (Exception e2) {
                            try {
                                finalRoomName = rs.getNString("RoomTypeName"); // Thử cột dự phòng 2
                            } catch (Exception e3) {
                                // Giữ nguyên giá trị mặc định nếu tất cả các cột trên đều không có trong DB
                            }
                        }
                    }
                    r.setRoomName(finalRoomName);
                    r.setRoomTypeName(finalRoomName);

                    // Bọc bảo vệ cột mô tả
                    try {
                        r.setDescription(rs.getString("Description"));
                    } catch (Exception e) {
                        r.setDescription("Phòng nghỉ cao cấp đầy đủ tiện nghi, không gian thoáng mát, view đẹp.");
                    }

                    r.setPrice(rs.getDouble("Price"));
                    r.setMaxAdults(rs.getInt("MaxAdults"));
                    r.setMaxChildren(rs.getInt("MaxChildren"));

                    // Bọc bảo vệ cột diện tích
                    try {
                        r.setArea(rs.getInt("Area"));
                    } catch (Exception e) {
                        r.setArea(35);
                    }

                    // Bọc bảo vệ cột ảnh
                    try {
                        String img = rs.getString("Image");
                        r.setImage(img != null && !img.isEmpty() ? img : "https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=500");
                    } catch (Exception e) {
                        r.setImage("https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=500");
                    }

                    r.setHasBathtub(true);
                    r.setHasBreakfast(true);
                    r.setRecommended(false);

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

        try (Connection conn = DBConnect.getConnection(); // Cậu thay bằng đoạn lấy Connection chuẩn của nhóm cậu nhé, ví dụ: DBContext.makeConnection() hoặc từ class của cậu
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    role = rs.getString("Role").trim(); // Lấy giá trị cột Role từ Database
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return role;
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




    public List<User> findAll() {
        jakarta.persistence.EntityManager em = Utils.JpaUtils.getEntityManager();
        try {
            jakarta.persistence.TypedQuery<User> query = em.createQuery("SELECT u FROM User u", User.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }
    private EntityManager em = JpaUtils.getEntityManager();
    public List<User> getAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.isActive = true";
            return em.createQuery(jpql, User.class).getResultList();
        } finally {
            em.close(); // Đóng kết nối an toàn
        }
    }

    public User findById(int id){
        EntityManager em = JpaUtils.getEntityManager();
        try
        {
            String sql = "SELECT u FROM User u WHERE u.id = :id and  u.isActive = true";
            TypedQuery<User> query = em.createQuery(sql, User.class);
            query.setParameter("id", id);
            return query.getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return null;
    }
    public void update(User user) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(user); // Merge dùng để cập nhật thực thể đã tồn tại xuống DB
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
}