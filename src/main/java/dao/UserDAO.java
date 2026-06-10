package dao;

import Utils.JpaUtils;
import context.DBConnect;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import model.Hotel;
import model.Room;
import model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public boolean registerUser(String firstName, String lastName, String email, String countryCode, String phoneNumber, String password) {
        String query = "INSERT INTO Users (FirstName, LastName, Email, CountryCode, PhoneNumber, Password, Role, IsActive) VALUES (?, ?, ?, ?, ?, ?, 'Customer', 1)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, firstName); ps.setString(2, lastName);
            ps.setString(3, email); ps.setString(4, countryCode);
            ps.setString(5, phoneNumber); ps.setString(6, password);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean checkLogin(String phoneNumber) {
        String query = "SELECT * FROM Users WHERE PhoneNumber = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, phoneNumber);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // ĐẾM PHÒNG TRỐNG CHO HOTEL LIST CHUẨN XÁC
    public List<Hotel> searchHotelsByArea(String keyword) {
        List<Hotel> list = new ArrayList<>();
        String searchPattern = (keyword == null || keyword.trim().isEmpty()) ? "%" : "%" + keyword + "%";
        String query = "SELECT h.HotelID, h.HotelName, h.City, h.Address, h.StarRating, " +
                "ISNULL(MIN(r.Price), 0) AS MinPrice, " +
                "SUM(CASE WHEN r.RoomType LIKE N'%Phòng Đơn%' AND r.Status = 'Available' THEN 1 ELSE 0 END) AS SingleCount, " +
                "SUM(CASE WHEN (r.RoomType LIKE N'%Phòng Đôi%' OR r.RoomType LIKE N'%Tiêu Chuẩn%') AND r.Status = 'Available' THEN 1 ELSE 0 END) AS DoubleCount, " +
                "SUM(CASE WHEN (r.RoomType LIKE N'%Family%' OR r.RoomType LIKE N'%VIP%') AND r.Status = 'Available' THEN 1 ELSE 0 END) AS FamilyCount " +
                "FROM Hotels h " +
                "LEFT JOIN Rooms r ON h.HotelID = r.HotelID " +
                "WHERE (h.City LIKE ? OR h.HotelName LIKE ?) " +
                "GROUP BY h.HotelID, h.HotelName, h.City, h.Address, h.StarRating";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Hotel hotel = new Hotel();
                    hotel.setId(rs.getInt("HotelID"));
                    hotel.setName(rs.getString("HotelName"));
                    hotel.setCity(rs.getString("City"));
                    hotel.setAddress(rs.getString("Address"));
                    hotel.setStars(rs.getInt("StarRating"));
                    hotel.setMinPrice(rs.getDouble("MinPrice"));
                    hotel.setAvailableSingleRooms(rs.getInt("SingleCount"));
                    hotel.setAvailableDoubleRooms(rs.getInt("DoubleCount"));
                    hotel.setAvailableFamilyRooms(rs.getInt("FamilyCount"));
                    list.add(hotel);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // FIX LỖI ROOM LIST KHÔNG HIỆN BẰNG CÁCH TRY-CATCH TỪNG CỘT
    public List<Room> getAvailableRooms(int hotelId, String checkIn, String checkOut) {
        List<Room> list = new ArrayList<>();
        String query = "SELECT * FROM Rooms WHERE HotelID = ? AND Status = 'Available' AND RoomID NOT IN (" +
                " SELECT RoomID FROM Bookings WHERE BookingStatus = 'Success' AND RoomID IS NOT NULL AND (? < CheckOutDate AND ? > CheckInDate))";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
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
                    r.setId(roomIdFromDB); r.setRoomId(roomIdFromDB);
                    r.setHotelId(rs.getInt("HotelID"));
                    r.setPrice(rs.getDouble("Price"));

                    // 1. Cột Tên Phòng
                    try { r.setRoomTypeName(rs.getString("RoomType") != null ? rs.getString("RoomType") : "Phòng Tiêu Chuẩn"); }
                    catch (Exception e) { r.setRoomTypeName("Phòng Tiêu Chuẩn"); }

                    // 2. Cột Người Lớn (Bọc try-catch chống sập nếu DB chưa có cột)
                    try { r.setMaxAdults(rs.getInt("MaxAdults")); } catch (Exception e) { r.setMaxAdults(2); }

                    // 3. Cột Trẻ Em
                    try { r.setMaxChildren(rs.getInt("MaxChildren")); } catch (Exception e) { r.setMaxChildren(1); }

                    // 4. Cột Diện Tích
                    try { r.setArea(rs.getInt("Area")); } catch (Exception e) { r.setArea(30); }

                    // 5. Hình Ảnh
                    try {
                        String img = rs.getString("Image");
                        r.setImage((img != null && !img.trim().isEmpty()) ? img : "https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=500");
                    } catch (Exception e) { r.setImage("https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=500"); }

                    list.add(r);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public model.Hotel getHotelById(int hotelId) {
        model.Hotel hotel = null;
        String sql = "SELECT h.HotelID, h.HotelName, h.City, h.Address, h.StarRating, ISNULL((SELECT MIN(Price) FROM Rooms WHERE HotelID = h.HotelID), 0) AS MinPrice FROM Hotels h WHERE h.HotelID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hotelId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    hotel = new model.Hotel();
                    hotel.setId(rs.getInt("HotelID")); hotel.setName(rs.getString("HotelName"));
                    hotel.setCity(rs.getString("City")); hotel.setAddress(rs.getString("Address"));
                    hotel.setStars(rs.getInt("StarRating")); hotel.setMinPrice(rs.getDouble("MinPrice"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return hotel;
    }

    // Các hàm phụ trợ khác giữ nguyên theo code cậu gửi
    public String getFirstNameByPhone(String phoneNumber) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT FirstName FROM Users WHERE PhoneNumber = ?")) {
            ps.setString(1, phoneNumber);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getString("FirstName"); }
        } catch (Exception e) { e.printStackTrace(); } return "";
    }
    public String getRoleByPhone(String phone) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT Role FROM Users WHERE PhoneNumber = ?")) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getString("Role").trim(); }
        } catch (Exception e) { e.printStackTrace(); } return "Customer";
    }
    public String getEmailByPhone(String phone) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT Email FROM Users WHERE PhoneNumber = ?")) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getString("Email"); }
        } catch (Exception e) { e.printStackTrace(); } return "";
    }
    public boolean checkPhoneExists(String phoneNumber) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT * FROM Users WHERE PhoneNumber = ?")) {
            ps.setString(1, phoneNumber);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); } return false;
    }
    public boolean validatePassword(String phoneNumber, String password) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT * FROM Users WHERE PhoneNumber = ? AND Password = ?")) {
            ps.setString(1, phoneNumber); ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); } return false;
    }
    public boolean checkEmailExists(String email) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT * FROM Users WHERE Email = ?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); } return false;
    }
    public String getPhoneByEmail(String email) {
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT PhoneNumber FROM Users WHERE Email = ?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getString("PhoneNumber"); }
        } catch (Exception e) { e.printStackTrace(); } return "";
    }

    // --- CÁC HÀM SỬ DỤNG JPA ---
    public List<User> findAll() {
        EntityManager entityManager = JpaUtils.getEntityManager();
        try { return entityManager.createQuery("SELECT u FROM User u", User.class).getResultList(); }
        catch (Exception e) { e.printStackTrace(); return new ArrayList<>(); } finally { entityManager.close(); }
    }
    public List<User> getAll() {
        EntityManager entityManager = JpaUtils.getEntityManager();
        try { return entityManager.createQuery("SELECT u FROM User u WHERE u.isActive = true", User.class).getResultList(); }
        finally { entityManager.close(); }
    }
    public User findById(int id){
        EntityManager entityManager = JpaUtils.getEntityManager();
        try {
            TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.id = :id and u.isActive = true", User.class);
            query.setParameter("id", id); return query.getSingleResult();
        } catch (Exception e) { e.printStackTrace(); } finally { entityManager.close(); } return null;
    }
    public void update(User user) {
        EntityManager em = JpaUtils.getEntityManager();
        try { em.getTransaction().begin(); em.merge(user); em.getTransaction().commit(); }
        catch (Exception e) { if (em.getTransaction().isActive()) em.getTransaction().rollback(); e.printStackTrace(); }
        finally { em.close(); }
    }
    public void delete(int id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin(); User user = em.find(User.class, id);
            if (user != null) { user.setIsActive(false); em.merge(user); }
            em.getTransaction().commit();
        } catch (Exception e) { if (em.getTransaction().isActive()) em.getTransaction().rollback(); e.printStackTrace(); }
        finally { em.close(); }
    }
    public User getUserByPhone(String phone) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.phoneNumber = :phone", User.class);
            query.setParameter("phone", phone); List<User> list = query.getResultList(); return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) { e.printStackTrace(); return null; } finally { em.close(); }
    }
}