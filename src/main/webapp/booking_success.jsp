<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Đặt phòng thành công</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --card-bg: #ffffff;
            --text-color: #212529;
            --sub-text: #6c757d;
            --border-color: #e0e0e0;
            --primary-blue: #2b5a9e;
            --primary-teal: #0097a7;
        }

        body {
            background-color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Thanh tiến trình */
        .booking-progress-bar {
            background: #ffffff;
            border-bottom: 1px solid var(--border-color);
            padding: 15px 0;
        }

        .progress-steps-container {
            max-width: 650px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            position: relative;
            padding: 0 40px;
        }

        .progress-line-back {
            position: absolute;
            top: 12px;
            left: 40px;
            right: 40px;
            height: 2px;
            background: #4caf50;
            z-index: 1;
        }

        .step-item {
            position: relative;
            z-index: 3;
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            text-align: center;
            font-size: 0.85rem;
            color: #4caf50;
            font-weight: bold;
        }

        .step-number {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #4caf50;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            margin-bottom: 8px;
        }

        /* Khung chính chứa hóa đơn */
        .success-main-container {
            max-width: 750px;
            margin: 40px auto;
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 35px;
            display: flex;
            gap: 25px;
            position: relative;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }

        .success-left {
            flex: 1.1;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .sparkle-key-container {
            position: relative;
            display: inline-block;
            margin-bottom: 20px;
            background: #fff8e1;
            width: 110px;
            height: 110px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .sparkle-key-container .main-key {
            font-size: 3.8rem;
            color: #ffb300;
            transform: rotate(-45deg);
            display: inline-block;
            text-shadow: 0 2px 8px rgba(255, 179, 0, 0.3);
        }

        .sparkle-key-container .sparkle {
            position: absolute;
            color: #ffd700;
        }

        .sparkle-key-container .sp-1 { top: 15px; left: 15px; font-size: 1.3rem; color: #ffca28; }
        .sparkle-key-container .sp-2 { top: 10px; right: 20px; font-size: 0.9rem; }
        .sparkle-key-container .sp-3 { bottom: 20px; right: 15px; font-size: 1.2rem; color: #ffca28; }

        .success-right {
            flex: 0.9;
            background: #fffdf0;
            border: 1px dashed #e0dcb0;
            border-radius: 12px;
            padding: 20px;
            position: relative;
        }

        .success-right::before {
            content: "";
            position: absolute;
            top: -6px; left: 0; right: 0;
            height: 12px;
            background-image: radial-gradient(circle, rgba(255,255,255,0) 4px, #ffffff 5px);
            background-size: 12px 12px;
            transform: rotate(180deg);
        }

        .success-right::after {
            content: "";
            position: absolute;
            bottom: -6px; left: 0; right: 0;
            height: 12px;
            background-image: radial-gradient(circle, rgba(255,255,255,0) 4px, #ffffff 5px);
            background-size: 12px 12px;
        }

        .success-title {
            color: #1e62d0;
            font-size: 1.8rem;
            font-weight: 800;
            margin: 10px 0;
            letter-spacing: 0.5px;
        }

        .success-subtext {
            font-size: 0.9rem;
            color: #333;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .booking-code-box {
            font-size: 1.6rem;
            font-weight: bold;
            color: #000;
            margin: 10px 0 25px 0;
            background: #f1f5f9;
            padding: 8px 20px;
            border-radius: 8px;
            display: inline-block;
        }

        .ticket-label {
            font-size: 0.85rem;
            color: #888888;
            margin-bottom: 2px;
        }
        .ticket-value {
            font-size: 1.05rem;
            font-weight: bold;
            color: #000;
            margin-bottom: 15px;
        }

        .discount-ribbon {
            background: #d32f2f;
            color: #fff;
            padding: 6px 15px;
            font-weight: bold;
            font-size: 1rem;
            display: inline-block;
            margin: 10px 0;
            clip-path: polygon(0 0, 100% 0, 90% 50%, 100% 100%, 0 100%);
        }

        .total-price-row {
            border-top: 1px dashed #cccccc;
            margin-top: 20px;
            padding-top: 15px;
        }

        .support-info-box {
            border: 1px solid #1e62d0;
            background: rgba(30, 98, 208, 0.02);
            border-radius: 6px;
            padding: 12px;
            text-align: left;
            font-size: 0.75rem;
            color: #444;
            margin-top: 20px;
            width: 100%;
            box-sizing: border-box;
            line-height: 1.4;
        }

        .btn-group-container {
            display: flex;
            gap: 15px;
            margin-top: 15px;
            width: 100%;
            justify-content: center;
        }

        .btn-action {
            padding: 12px 25px;
            border-radius: 25px;
            border: none;
            color: #fff;
            font-weight: bold;
            font-size: 0.95rem;
            cursor: pointer;
            text-decoration: none;
            min-width: 140px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            transition: transform 0.2s, opacity 0.2s;
        }

        .btn-home { background-color: #2b5a9e; }
        .btn-gmail { background-color: #4b7bc7; }
        .btn-action:hover { transform: translateY(-1px); opacity: 0.95; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="booking-progress-bar">
    <div class="progress-steps-container">
        <div class="progress-line-back"></div>
        <div class="step-item">
            <div class="step-number"><i class="fa-solid fa-check"></i></div>
            <span>Thông tin khách hàng</span>
        </div>
        <div class="step-item">
            <div class="step-number"><i class="fa-solid fa-check"></i></div>
            <span>Chi tiết thanh toán</span>
        </div>
        <div class="step-item">
            <div class="step-number"><i class="fa-solid fa-check"></i></div>
            <span>Hoàn thành đặt chỗ</span>
        </div>
    </div>
</div>

<div class="success-main-container">

    <div class="success-left">
        <div class="sparkle-key-container">
            <i class="fa-solid fa-wand-magic-sparkles sparkle sp-1"></i>
            <i class="fa-solid fa-star sparkle sp-2"></i>
            <i class="fa-solid fa-key main-key"></i>
            <i class="fa-solid fa-star sparkle sp-3"></i>
        </div>

        <div class="success-title">ĐẶT PHÒNG THÀNH CÔNG!</div>
        <div class="success-subtext">
            Cảm ơn "<strong>${not empty customerName ? customerName : 'Quý khách'}</strong>" đã lựa chọn "<strong>${not empty hotelName ? hotelName : 'Verdelle Hotel'}</strong>".<br>
            Chúng tôi rất hân hạnh được phục vụ bạn.
        </div>

        <div class="booking-code-box">
            Mã xác nhận: #${not empty bookingId ? bookingId : 'VDL9999'}
        </div>

        <div class="btn-group-container">
            <a href="${pageContext.request.contextPath}/home.jsp" class="btn-action btn-home">Về Trang Chủ</a>

            <a href="SendEmailController?bookingId=${not empty bookingId ? bookingId : 'VDL9999'}" class="btn-action btn-gmail">
                <i class="fa-regular fa-envelope"></i> Gửi về Gmail
            </a>
        </div>
    </div>

    <div class="success-right">
        <div class="ticket-label">Khách sạn:</div>
        <div class="ticket-value">"${not empty hotelName ? hotelName : 'Verdelle Hotel Luxury'}"</div>

        <div class="ticket-label">Phòng:</div>
        <div class="ticket-value">${not empty requiredRooms ? requiredRooms : '1'} x phòng "${not empty roomName ? roomName : 'Standard Room'}"</div>

        <div class="ticket-label">Thanh toán:</div>
        <div class="ticket-value" style="color: #4caf50;">Đã thanh toán (via QR)</div>

        <div class="total-price-row">
            <div class="ticket-label" style="font-weight: bold; color: #333;">Tổng cộng:</div>
            <div style="font-size: 1.6rem; font-weight: 900; color: #000; margin-top: 5px;">
                <fmt:formatNumber value="${finalPrice}" type="number" groupingUsed="true"/> đ
            </div>
        </div>

        <div class="support-info-box">
            <strong style="display:block; margin-bottom:5px; font-size: 0.8rem; color: #1e62d0;"><i class="fa-solid fa-circle-info"></i> Thông tin hỗ trợ</strong>
            Một email chi tiết kèm hướng dẫn nhận phòng đã được gửi đến email của bạn.<br>
            Cần hỗ trợ gấp? Gọi ngay <strong>Hotline: 0834178906</strong>
        </div>
    </div>

</div>

<div style="margin-top: 40px;"></div>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('status')) {
        const status = urlParams.get('status');

        if (status === 'emailSent') {
            alert("✉️ Hệ thống đã gửi hóa đơn thành công vào Gmail của bạn!");
        } else if (status === 'emailFailed') {
            alert("❌ Gửi mail thất bại! Vui lòng kiểm tra lại cấu hình thông tin gửi.");
        } else if (status === 'emailNotLoggedIn') {
            alert("⚠️ Không tìm thấy email khách hàng! Bạn cần đăng nhập để sử dụng chức năng này.");
        }

        // Xóa tham số status trên URL sau khi thông báo xong để giao diện sạch sẽ
        window.history.replaceState({}, document.title, window.location.pathname);
    }
</script>

</body>
<footer>
    <jsp:include page="footer.jsp" />
</footer>
</html>