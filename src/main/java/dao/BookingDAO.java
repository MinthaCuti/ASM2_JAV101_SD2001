package dao;

import context.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Date;
import java.time.LocalDate;

public class BookingDAO {

    public boolean createBookingWithCommission(int customerId, int roomId, LocalDate checkIn, LocalDate checkOut, long totalAmount, String customerName, String bookingCode, String status) {
        String insertBookingSQL = "INSERT INTO Bookings (CustomerID, RoomID, CheckInDate, CheckOutDate, TotalPrice, BookingStatus) VALUES (?, ?, ?, ?, ?, 'Confirmed')";
        // Tìm dòng này trong BookingDAO của cậu và thay thế:
        String insertCommissionSQL = "INSERT INTO Commissions (booking_id, customer_name, booking_date, payment_date, total_amount, commission_rate, commission_amount, status) VALUES (?, ?, ?, ?, ?, 10.0, ?, ?)";

        Connection conn = null;
        PreparedStatement psBooking = null;
        PreparedStatement psCommission = null;

        try {
            conn = context.DBConnect.getConnection();
            conn.setAutoCommit(false); // Bật tính năng Transaction

            // 1. Thực thi lưu đơn Bookings
            psBooking = conn.prepareStatement(insertBookingSQL);
            psBooking.setInt(1, customerId);
            psBooking.setInt(2, roomId);
            psBooking.setDate(3, java.sql.Date.valueOf(checkIn));
            psBooking.setDate(4, java.sql.Date.valueOf(checkOut));
            psBooking.setBigDecimal(5, new java.math.BigDecimal(totalAmount));
            psBooking.executeUpdate();

            // 2. Thực thi lưu Commissions bằng chính mã ngẫu nhiên VDxxxxxx truyền từ Controller sang
            double commissionAmount = totalAmount * 0.10; // Tính 10% hoa hồng mặc định
            LocalDate today = LocalDate.now();

            psCommission = conn.prepareStatement(insertCommissionSQL);
            psCommission.setString(1, bookingCode); // Đẩy mã VDxxxxxx vào đây
            psCommission.setString(2, customerName);
            psCommission.setDate(3, java.sql.Date.valueOf(today));
            psCommission.setDate(4, java.sql.Date.valueOf(today));
            psCommission.setBigDecimal(5, new java.math.BigDecimal(totalAmount));
            psCommission.setBigDecimal(6, new java.math.BigDecimal(commissionAmount));
            psCommission.setString(7, status);
            psCommission.executeUpdate();

            conn.commit(); // Thành công hết thì chốt đơn xuống DB
            return true;
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback(); // Gặp lỗi bất kỳ là hủy sạch bảo toàn dữ liệu
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (psBooking != null) psBooking.close();
                if (psCommission != null) psCommission.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}