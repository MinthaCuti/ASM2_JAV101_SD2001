<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Chi tiết thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/RoomListStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-color: #dce7f7;
            --card-bg: #ffffff;
            --text-color: #212529;
            --sub-text: #6c757d;
            --border-color: #e0e0e0;
            --primary-teal: #0097a7;
            --btn-success: #43a047;
            --progress-bg: #f1f3f5;
            --step-num-bg: #e0e0e0;
            --step-num-text: #495057;
            --item-hover-bg: #f8f9fa;
        }

        body.dark-mode {
            --bg-color: #0a0a0a;
            --card-bg: #1e1e1e;
            --text-color: #ffffff;
            --sub-text: #888888;
            --border-color: #2d2d2d;
            --primary-teal: #00bcd4;
            --btn-success: #4caf50;
            --progress-bg: #161616;
            --step-num-bg: #333333;
            --step-num-text: #ffffff;
            --item-hover-bg: #242424;
        }

        /* Thanh tiến trình đặt phòng (Booking Steps) - Bước 2 Active */
        .booking-progress-bar {
            background: var(--progress-bg);
            border-bottom: 1px solid var(--border-color);
            padding: 20px 0;
            transition: background 0.3s, border-color 0.3s;
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
            background: var(--border-color);
            z-index: 1;
        }

        .progress-line-fill {
            position: absolute;
            top: 12px;
            left: 40px;
            width: 50%; /* Tiến trình chạy đến bước 2 */
            height: 2px;
            background: var(--primary-teal);
            z-index: 2;
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
            color: var(--sub-text);
            font-weight: 500;
        }

        .step-item.completed {
            color: #4caf50;
        }

        .step-item.active {
            color: var(--primary-teal);
            font-weight: bold;
        }

        .step-number {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: var(--step-num-bg);
            color: var(--step-num-text);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            margin-bottom: 8px;
        }

        .step-item.completed .step-number {
            background: #4caf50;
            color: #fff;
        }

        .step-item.active .step-number {
            background: var(--primary-teal);
            color: #000;
            box-shadow: 0 0 10px rgba(0, 188, 212, 0.4);
        }

        body.dark-mode .step-item.active .step-number {
            color: #ffffff;
        }

        /* Phương thức thanh toán */
        .payment-method-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 15px;
        }

        .method-option {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .method-option:hover {
            background: var(--item-hover-bg);
            border-color: var(--primary-teal);
        }

        .method-option input[type="radio"] {
            accent-color: var(--primary-teal);
            width: 18px;
            height: 18px;
            margin-top: 2px;
        }

        /* Khung hiển thị QR code */
        .qr-display-box {
            width: 250px;
            height: 250px;
            border: 1px solid var(--text-color);
            margin: 20px auto;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.5rem;
            background: #fff;
            color: #000;
        }

        /* Phần thông báo điều khoản */
        .policy-agreement-text {
            font-size: 0.8rem;
            color: var(--sub-text);
            line-height: 1.5;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid var(--border-color);
        }

        .policy-agreement-text a {
            color: var(--primary-teal);
            text-decoration: none;
        }

        /* Nút chờ thanh toán tinh chỉnh */
        .btn-waiting-payment {
            width: 100%;
            padding: 15px;
            background: #cccccc;
            color: #666663;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: bold;
            text-transform: uppercase;
            cursor: not-allowed;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 15px;
        }

        body.dark-mode .btn-waiting-payment {
            background: #333333;
            color: #888888;
        }

        /* Cột tóm tắt khuyến mãi giá */
        .discount-badge {
            background: #d32f2f;
            color: #fff;
            padding: 5px 12px;
            font-weight: bold;
            border-radius: 4px;
            display: inline-block;
            margin-bottom: 15px;
            font-size: 0.9rem;
        }

        .price-breakdown-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
            margin-bottom: 10px;
            color: var(--text-color);
        }

        .final-price-box {
            border-top: 1px dashed var(--border-color);
            margin-top: 15px;
            padding-top: 15px;
        }

        /* Timeline hủy phòng */
        .timeline-container {
            margin-top: 15px;
            position: relative;
        }
        .timeline-line {
            height: 4px;
            background: #4caf50;
            border-radius: 2px;
            position: relative;
            margin-bottom: 10px;
        }
        .timeline-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #ccc;
            position: absolute;
            top: -4px;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="booking-progress-bar">
    <div class="progress-steps-container">
        <div class="progress-line-back"></div>
        <div class="progress-line-fill"></div>
        <div class="step-item completed">
            <div class="step-number"><i class="fa-solid fa-check"></i></div>
            <span>Thông tin khách hàng</span>
        </div>
        <div class="step-item active">
            <div class="step-number">2</div>
            <span>Chi tiết thanh toán</span>
        </div>
        <div class="step-item">
            <div class="step-number">3</div>
            <span>Hoàn thành đặt chỗ</span>
        </div>
    </div>
</div>

<div class="main-content-container">
    <div class="details-split-layout" style="margin-top: 20px;">

        <div class="details-left-content">
            <div class="info-card-block">
                <div class="block-title"><i class="fa-solid fa-lock"></i> Phương thức thanh toán</div>
                <p style="font-size: 0.85rem; color: #0288d1; margin: -5px 0 15px 0;">
                    <i class="fa-solid fa-shield-halved"></i> Mọi người liệu thanh toán được mã hóa và bảo mật
                </p>

                <div class="payment-method-container">
                    <label class="method-option">
                        <input type="radio" name="paymentMethod" value="direct">
                        <div>
                            <strong style="font-size: 0.95rem; display:block; margin-bottom:2px;">Thanh toán trực tiếp cho chỗ nghỉ.</strong>
                            <span style="font-size: 0.85rem; color: var(--sub-text);">Quý khách sẽ thanh toán bằng tiền mặt hoặc thẻ tại quầy lễ tân khi đến nhận phòng.</span>
                        </div>
                    </label>

                    <label class="method-option">
                        <input type="radio" name="paymentMethod" value="qr" checked>
                        <div>
                            <strong style="font-size: 0.95rem; display:block; margin-bottom:2px;">Thanh toán qua QR</strong>
                            <span style="font-size: 0.85rem; color: var(--sub-text);">Quét mã chuyển khoản nhanh qua ngân hàng để xác nhận phòng lập tức.</span>
                        </div>
                    </label>
                </div>

                <div id="qr-section">
                    <div class="qr-display-box">
                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=https://grievous-dimmed-sassy.ngrok-free.dev${pageContext.request.contextPath}/FakeBankController?roomId=${roomId}%26amount=${finalPrice}" alt="QR Payment" style="width:200px; height:200px;">
                    </div>
                </div>

                <div class="policy-agreement-text">
                    Thực hiện bước tiếp theo đồng nghĩa với việc quý khách chấp nhận tuân theo
                    <a href="#">Điều khoản Sử dụng</a> và <a href="#">Chính sách Quyền riêng tư</a> của Verdelle Hotel.
                </div>
            </div>

            <form action="FinalizeBookingController" method="POST">
                <input type="hidden" name="roomId" value="${roomId}">
                <input type="hidden" name="customerName" value="${customerName}">
                <button type="submit" class="btn-waiting-payment">
                    <i class="fa-solid fa-lock"></i> CHỜ THANH TOÁN
                </button>
            </form>
            <p style="text-align: center; font-size: 0.85rem; color: #4caf50; margin-top: 10px; font-weight: 500;">
                An tâm thay đổi! Hủy miễn phí
            </p>
        </div>

        <div class="details-right-sidebar">

            <div style="background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 12px; padding: 20px; margin-bottom: 20px;">
                <h4 style="font-size: 1.15rem; font-weight: bold; margin: 0 0 5px 0; color: var(--text-color);">Khách sạn "${not empty hotelName ? hotelName : 'N/A'}"</h4>
                <p style="font-size: 0.85rem; color: var(--sub-text); margin: 0 0 10px 0;">
                    <i class="fa-regular fa-calendar-days"></i> ${not empty dateRange ? dateRange : 'Date, dd/mm - Date, dd/mm'}
                </p>
                <ul style="padding-left: 15px; margin: 0; font-size: 0.85rem; color: var(--sub-text); line-height: 1.6;">
                    <li>${not empty totalNights ? totalNights : 'N/A'} đêm</li>
                    <li>${not empty requiredRooms ? requiredRooms : '1'} x Phòng "${not empty roomName ? roomName : 'N/A'}"</li>
                </ul>
            </div>

            <div style="background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 12px; padding: 20px; margin-bottom: 20px;">
                <div style="padding: 12px 15px; background: rgba(76, 175, 80, 0.06); border: 1px solid rgba(76, 175, 80, 0.15); border-radius: 8px; margin-bottom: 15px;">
                    <div style="font-size: 0.85rem; font-weight: bold; color: #4caf50; margin-bottom: 2px;">
                        <i class="fa-solid fa-thumbs-up"></i> Lựa chọn khách sạn tốt nhất
                    </div>
                    <div style="font-size: 0.8rem; color: var(--sub-text);">
                        Đánh giá trung bình của khách là <strong>8,5</strong>
                    </div>
                </div>

                <c:if test="${discount > 0}">
                    <div style="font-size:0.85rem; color:#d32f2f; font-weight:bold; text-align:center; padding: 10px; background: #ffebee; border-radius: 8px;">
                        <i class="fa-solid fa-tags"></i> Khớp giá ưu đãi! Quý khách tiết kiệm <fmt:formatNumber value="${discount}" type="number" groupingUsed="true"/> đ
                    </div>
                </c:if>
            </div>

            <div style="background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 12px; padding: 20px; margin-bottom: 20px;">

                <c:if test="${not empty voucherCode}">
                    <div class="discount-badge" style="background: #d32f2f; color: #fff; padding: 5px 12px; font-weight: bold; border-radius: 4px; display: inline-block; margin-bottom: 15px; font-size: 0.9rem;">
                        <i class="fa-solid fa-tag"></i> Đã áp dụng mã: ${voucherCode}
                    </div>
                </c:if>

                <div class="price-breakdown-row" style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 10px; color: #4caf50; font-weight: bold;">
                    <span>Phí đặt trước</span>
                    <span>MIỄN PHÍ</span>
                </div>

                <div class="price-breakdown-row" style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 10px; color: var(--text-color);">
                    <span>Giá gốc (${requiredRooms} phòng x ${totalNights} đêm)</span>
                    <c:choose>
                        <c:when test="${discount > 0}">
                            <span style="text-decoration: line-through;"><fmt:formatNumber value="${priceWithVAT}" type="number" groupingUsed="true"/> đ</span>
                        </c:when>
                        <c:otherwise>
                            <span><fmt:formatNumber value="${priceWithVAT}" type="number" groupingUsed="true"/> đ</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="price-breakdown-row" style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 10px; color: var(--text-color);">
                    <span>Giá phòng (${requiredRooms} phòng x 1 đêm)</span>
                    <span><fmt:formatNumber value="${basePrice * requiredRooms}" type="number" groupingUsed="true"/> đ</span>
                </div>

                <div class="price-breakdown-row" style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 10px; color: var(--text-color);">
                    <span>Thuế và phí (10% VAT)</span>
                    <span><fmt:formatNumber value="${taxAndFees}" type="number" groupingUsed="true"/> đ</span>
                </div>

                <c:if test="${discount > 0}">
                    <div class="price-breakdown-row" style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 10px; color: #d32f2f; font-weight: 500;">
                        <span>Giảm giá Voucher (15%)</span>
                        <span>- <fmt:formatNumber value="${discount}" type="number" groupingUsed="true"/> đ</span>
                    </div>
                </c:if>

                <div class="final-price-box price-breakdown-row" style="border-top: 1px dashed var(--border-color); margin-top: 15px; padding-top: 15px; display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-weight: bold; font-size: 1.1rem; color: var(--text-color);">Giá cuối cùng</span>
                    <span style="font-size: 1.6rem; font-weight: 900; color: #e65100;"><fmt:formatNumber value="${finalPrice}" type="number" groupingUsed="true"/> đ</span>
                </div>

                <p style="font-size: 0.75rem; color: var(--sub-text); text-align: right; margin: 5px 0 0 0;">
                    Giá đã bao gồm VAT: <fmt:formatNumber value="${taxAndFees}" type="number" groupingUsed="true"/> đ
                </p>
            </div>

            <div style="background: var(--card-bg); border: 1px solid var(--border-color); border-left: 4px solid #0288d1; border-radius: 4px 12px 12px 4px; padding: 15px; margin-bottom: 20px;">
                <strong style="font-size: 0.9rem; display: block; margin-bottom: 4px; color: var(--text-color);">Thông tin thanh toán</strong>
                <span style="font-size: 0.8rem; color: var(--sub-text); line-height: 1.4; display: block;">
                    Khách sạn sẽ thu tiền cho đặt phòng này, không phải Verdelle Hotel.
                </span>
            </div>

            <div style="background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 12px; padding: 20px;">
                <strong style="font-size: 0.9rem; display: block; margin-bottom: 4px; color: var(--text-color);">Nếu hủy phòng thì sẽ trả bao nhiêu?</strong>
                <p style="font-size: 0.8rem; color: #4caf50; margin: 0 0 15px 0; line-height: 1.4;">
                    <strong style="color: #4caf50;">An tâm thay đổi!</strong> Hủy miễn phí trước ngày nhận phòng. Dễ dàng chỉnh sửa đặt phòng trực tuyến – không tốn thêm chi phí! <a href="#" style="color:var(--primary-teal); text-decoration:none;">Xem thêm chi tiết</a>
                </p>

                <div class="timeline-container" style="position: relative; margin-top: 15px;">
                    <div class="timeline-line" style="height: 4px; background: #4caf50; border-radius: 2px; position: relative; margin-bottom: 10px;">
                        <div class="timeline-dot" style="width: 12px; height: 12px; border-radius: 50%; position: absolute; top: -4px; left: 0; background: #4caf50;"></div>
                        <div class="timeline-dot" style="width: 12px; height: 12px; border-radius: 50%; position: absolute; top: -4px; left: 50%; background: #4caf50;"></div>
                        <div class="timeline-dot" style="width: 12px; height: 12px; border-radius: 50%; position: absolute; top: -4px; right: 0; background: #ccc;"></div>
                    </div>
                    <div style="display: flex; justify-content: space-between; font-size: 0.75rem; color: var(--sub-text);">
                        <span>Hôm nay</span>
                        <span>Hạn hủy free</span>
                        <span>Ngày đến</span>
                    </div>
                </div>
            </div>


        </div>
    </div>
</div>

<div style="margin-top: 40px;"></div>
</body>
<footer>
    <jsp:include page="footer.jsp" />
</footer>
</html>

<style>
    /* Class bổ sung để đổi màu nút bấm thành xanh dương khi quét QR thành công */
    .btn-continue-active {
        background: #0288d1 !important;
        color: #ffffff !important;
        cursor: pointer !important;
    }
</style>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const radioMethods = document.querySelectorAll('input[name="paymentMethod"]');
        const qrSection = document.getElementById("qr-section");
        const targetForm = document.querySelector('form[action="FinalizeBookingController"]');

        if (!targetForm) return;

        const submitBtn = targetForm.querySelector('button[type="submit"]');
        const roomIdInput = targetForm.querySelector('input[name="roomId"]');
        if (!submitBtn || !roomIdInput) return;

        submitBtn.setAttribute("id", "submit-booking-btn");
        submitBtn.disabled = true;

        let pollingInterval = null;
        const roomId = roomIdInput.value;

        function verifyRealPayment() {
            const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

            if (selectedMethod === "direct") {
                if (qrSection) qrSection.style.display = "none";
                clearInterval(pollingInterval);

                submitBtn.innerHTML = "TIẾP TỤC";
                submitBtn.classList.add("btn-continue-active");
                submitBtn.disabled = false;
            } else {
                if (qrSection) qrSection.style.display = "block";

                submitBtn.innerHTML = '<i class="fa-solid fa-lock"></i> CHỜ THANH TOÁN';
                submitBtn.classList.remove("btn-continue-active");
                submitBtn.disabled = true;

                startRealTimeChecking();
            }
        }

        function startRealTimeChecking() {
            clearInterval(pollingInterval);

            pollingInterval = setInterval(function() {
                fetch('${pageContext.request.contextPath}/CheckPaymentStatusController?roomId=' + roomId)
                    .then(response => response.json())
                    .then(data => {
                        if (data.isPaid === true || data.isPaid === "true") {
                            clearInterval(pollingInterval);

                            submitBtn.innerHTML = "TIẾP TỤC";
                            submitBtn.classList.add("btn-continue-active");
                            submitBtn.disabled = false;
                        } else {
                            // Giữ trạng thái khóa nếu chưa hoàn thành thanh toán thực tế
                            if(!submitBtn.classList.contains("btn-continue-active")) {
                                submitBtn.innerHTML = '<i class="fa-solid fa-lock"></i> CHỜ THANH TOÁN';
                                submitBtn.disabled = true;
                            }
                        }
                    })
                    .catch(error => console.log("Đang chờ xác nhận từ điện thoại..."));
            }, 3000);
        }

        radioMethods.forEach(radio => radio.addEventListener("change", verifyRealPayment));
        verifyRealPayment();
    });
</script>