package controller;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Properties;

@WebServlet(name = "SendEmailController", value = "/SendEmailController")
public class SendEmailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 1. Tự động lấy email của người đang đăng nhập từ Session để làm người nhận
        String toEmail = (String) session.getAttribute("userEmail");
        String bookingId = request.getParameter("bookingId");

        // BẢO VỆ: Nếu chưa đăng nhập hoặc không tìm thấy email, quay về trang trước báo lỗi
        if (toEmail == null || toEmail.trim().isEmpty()) {
            System.out.println("⚠️ LỖI: Không tìm thấy userEmail trong Session. Code tự động dừng.");
            response.sendRedirect(request.getHeader("referer") + "?status=emailNotLoggedIn");
            return;
        }

        // ==============================================================================
        // 2. CẤU HÌNH GMAIL TỔNG ĐÀI GỬI ĐI (Dùng tài khoản mintringuyen1008@gmail.com)
        // ==============================================================================
        final String fromEmail = "mintringuyen1008@gmail.com";

        // Mật khẩu ứng dụng 16 ký tự
        final String appPassword = "ncjj hdlo pzzg hxyc";

        // 3. Thiết lập cổng kết nối SMTP với Google
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Đăng nhập ngầm vào Gmail gửi
        Session mailSession = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });

        try {
            // 4. Tạo nội dung Email dạng HTML
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(fromEmail, "Verdelle Premium Resort & Hotel"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));

            // Tiêu đề Email
            message.setSubject("[Verdelle Hotel] Xác nhận đặt phòng thành công " + bookingId);

            // Giao diện hóa đơn HTML gửi về mail khách hàng
            String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; max-width: 600px; margin: 0 auto;'>"
                    + "<h2 style='color: #1a73e8; text-align: center;'>CẢM ƠN BẠN ĐÃ ĐẶT PHÒNG TẠI VERDELLE!</h2>"
                    + "<p>Chào bạn, yêu cầu đặt phòng của bạn đã được hệ thống xác nhận thành công.</p>"
                    + "<div style='background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin: 15px 0;'>"
                    + "<p><b>Mã xác nhận:</b> <span style='font-size: 18px; color: #1a73e8; font-weight: bold;'>" + bookingId + "</span></p>"
                    + "<p><b>Khách sạn:</b> Verdelle Premium Resort & Hotel</p>"
                    + "<p><b>Chi tiết:</b> 4 x phòng Deluxe Hướng Biển (Deluxe Ocean View)</p>"
                    + "<p><b>Trạng thái:</b> Đã thanh toán (via QR) - Giảm 30%</p>"
                    + "</div>"
                    + "<h3 style='color: #d93025;'>Tổng cộng: 4,466,000 đ</h3>"
                    + "<hr>"
                    + "<p style='font-size: 12px; color: #777; text-align: center;'>Mọi thắc mắc xin vui lòng liên hệ Hotline: 0834178906.</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");

            // 5. Gửi mail
            System.out.println("🚀 Đang gửi mail từ " + fromEmail + " tới " + toEmail + "...");
            Transport.send(message);
            System.out.println("✅ GỬI MAIL THÀNH CÔNG! Check hộp thư đến ngay!");

            // ĐÃ SỬA: Gửi thành công -> Điều hướng thẳng về trang chủ home.jsp
            response.sendRedirect("home.jsp?status=emailSent");

        } catch (Exception e) {
            System.out.println("❌ GỬI MAIL THẤT BẠI! Lỗi chi tiết:");
            e.printStackTrace();

            // ĐÃ SỬA: Gửi thất bại -> Vẫn về trang chủ nhưng báo lỗi để user biết
            response.sendRedirect("home.jsp?status=emailFailed");
        }
    }
}