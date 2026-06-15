package dao;

import context.DBConnect;
import model.Room;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    // 1. Lấy tất cả các phòng thuộc sở hữu của Partner
    public List<Room> getRoomsByPartner(int ownerId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.* FROM Rooms r " +
                "JOIN Hotels h ON r.HotelID = h.HotelID " +
                "WHERE h.OwnerID = ? AND r.Status <> 'Deleted'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room();
                    int roomIdFromDB = rs.getInt("RoomID");

                    room.setId(roomIdFromDB);
                    room.setRoomId(roomIdFromDB);
                    room.setHotelId(rs.getInt("HotelID"));
                    room.setPrice(rs.getDouble("Price"));
                    room.setStatus(rs.getString("Status"));
                    room.setRoomTypeName(rs.getString("RoomType") != null ? rs.getString("RoomType") : "Phòng Tiêu Chuẩn");

                    try { room.setArea(rs.getInt("Area")); } catch (Exception e) { room.setArea(30); }
                    try { room.setMaxAdults(rs.getInt("MaxAdults")); } catch (Exception e) { room.setMaxAdults(2); }
                    try { room.setMaxChildren(rs.getInt("MaxChildren")); } catch (Exception e) { room.setMaxChildren(1); }

                    list.add(room);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Bật tắt trạng thái phòng nhanh
    public boolean toggleRoomStatus(int roomId, String newStatus, int ownerId) {
        String sql = "UPDATE Rooms SET Status = ? WHERE RoomID = ? " +
                "AND HotelID IN (SELECT HotelID FROM Hotels WHERE OwnerID = ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, roomId);
            ps.setInt(3, ownerId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Tìm chi tiết 1 phòng theo ID để đẩy dữ liệu cũ lên Form sửa
    public Room getRoomById(int roomId) {
        String sql = "SELECT * FROM Rooms WHERE RoomID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Room room = new Room();
                    room.setRoomId(rs.getInt("RoomID"));
                    room.setHotelId(rs.getInt("HotelID"));
                    room.setRoomTypeName(rs.getString("RoomType"));
                    room.setPrice(rs.getDouble("Price"));
                    room.setStatus(rs.getString("Status"));
                    room.setMaxPeople(rs.getInt("MaxPeople"));
                    room.setArea(rs.getInt("Area"));
                    return room;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 4. Cập nhật thông tin phòng xuống Database sau khi ấn nút lưu thay đổi
    public boolean updateRoom(Room room) {
        String sql = "UPDATE Rooms SET RoomType = ?, Price = ?, Status = ?, MaxPeople = ?, Area = ? WHERE RoomID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, room.getRoomTypeName());
            ps.setDouble(2, room.getPrice());
            ps.setString(3, room.getStatus());
            ps.setInt(4, room.getMaxPeople());
            ps.setInt(5, room.getArea());
            ps.setInt(6, room.getRoomId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    // 5. Hàm xóa phòng dựa vào RoomID
    public boolean deleteRoom(int roomId) {
        String sql = "UPDATE Rooms SET Status = 'Deleted' WHERE RoomID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 6. Hàm tạo phòng mới
    public boolean addRoom(Room room) {
        String sql = "INSERT INTO Rooms (RoomNumber, RoomType, Price, Status, HotelID, MaxPeople, Area) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, room.getRoomNumber());
            ps.setString(2, room.getRoomTypeName());
            ps.setDouble(3, room.getPrice());
            ps.setString(4, room.getStatus());
            ps.setInt(5, room.getHotelId());
            ps.setInt(6, room.getMaxPeople());
            ps.setInt(7, room.getArea());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}