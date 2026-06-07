<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Đặt phòng & Thanh toán</title>
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
            --input-bg: #f1f3f5;
            --modal-overlay: rgba(0, 0, 0, 0.5);
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
            --input-bg: #121212;
            --modal-overlay: rgba(0, 0, 0, 0.75);
        }

        /* Thanh tiến trình đặt phòng (Booking Steps) */
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
            transition: background 0.3s;
        }

        .progress-line-fill {
            position: absolute;
            top: 12px;
            left: 40px;
            width: 0%;
            height: 2px;
            background: var(--primary-teal);
            z-index: 2;
            transition: width 0.3s ease, background 0.3s;
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
            transition: color 0.3s;
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
            margin-bottom: 8px; /* Tăng nhẹ khoảng cách giữa vòng tròn và chữ */
            transition: all 0.3s;
        }

        .step-item.active .step-number {
            background: var(--primary-teal);
            color: #000;
            box-shadow: 0 0 10px rgba(0, 188, 212, 0.4);
        }

        body.dark-mode .step-item.active .step-number {
            color: #ffffff;
        }

        /* Tinh chỉnh khối thông tin */
        .relative-block {
            position: relative;
        }
        .btn-edit-trigger {
            position: absolute;
            bottom: 20px;
            right: 20px;
            background: transparent;
            border: none;
            color: var(--primary-teal);
            text-decoration: underline;
            font-size: 0.85rem;
            cursor: pointer;
            font-weight: 600;
            transition: color 0.3s;
        }
        .btn-edit-trigger:hover {
            color: #00e5ff;
        }

        /* Hộp checkbox tùy chọn đặc biệt */
        .custom-checkbox-label {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            margin-bottom: 10px;
            cursor: pointer;
            color: var(--text-color);
            transition: all 0.3s;
        }
        .custom-checkbox-label:hover {
            border-color: var(--primary-teal);
            background: var(--item-hover-bg);
        }
        .custom-checkbox-label input[type="checkbox"] {
            accent-color: var(--primary-teal);
            width: 16px;
            height: 16px;
        }

        /* Tóm tắt ngày nhận/trả phòng ở cột phải */
        .booking-summary-dates {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            margin-bottom: 20px;
            text-align: center;
            transition: background 0.3s, border-color 0.3s;
        }
        .date-box-item {
            flex: 1;
        }
        .date-box-label {
            font-size: 0.7rem;
            color: var(--sub-text);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
            transition: color 0.3s;
        }
        .date-box-value {
            font-size: 1rem;
            font-weight: bold;
            color: var(--text-color);
            transition: color 0.3s;
        }

        /* Khối tổng tiền chốt đơn */
        .price-final-card {
            background: var(--card-bg);
            border: 2px solid var(--primary-teal);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 0 15px rgba(0, 188, 212, 0.1);
            color: var(--text-color);
            transition: all 0.3s;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .btn-checkout-submit {
            width: 100%;
            margin-top: 15px;
            padding: 14px;
            background: var(--btn-success);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            font-size: 1rem;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-checkout-submit:hover {
            background: #45a049;
            box-shadow: 0 0 15px rgba(76, 175, 80, 0.4);
        }

        /* CSS CUSTOM POPUP MODAL ĐỒNG BỘ DARK MODE CỦA MINT (KHÔNG XÀI TAILWIND) */
        .custom-modal-overlay {
            position: fixed;
            inset: 0;
            background: var(--modal-overlay);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            z-index: 999;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s ease, background 0.3s;
        }
        .custom-modal-overlay.show {
            opacity: 1;
            pointer-events: auto;
        }
        .custom-modal-card {
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            width: 100%;
            max-width: 650px;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            transform: translateY(-20px);
            transition: transform 0.3s ease;
            color: var(--text-color);
        }
        .custom-modal-overlay.show .custom-modal-card {
            transform: translateY(0);
        }
        .modal-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
            margin-top: 20px;
        }
        .modal-col-full {
            grid-column: span 2;
        }
        .modal-input-wrapper {
            position: relative;
            border: 1px solid var(--border-color);
            background: var(--input-bg);
            border-radius: 8px;
            padding: 8px 12px;
            transition: background 0.3s, border-color 0.3s;
        }
        .modal-input-wrapper:focus-within {
            border-color: var(--primary-teal);
        }
        .modal-input-wrapper label {
            position: absolute;
            top: -9px;
            left: 10px;
            background: var(--card-bg);
            padding: 0 5px;
            font-size: 0.75rem;
            color: var(--primary-teal);
            font-weight: 600;
            transition: background 0.3s;
        }
        .modal-input-wrapper input {
            width: 100%;
            background: transparent;
            border: none;
            outline: none;
            color: var(--text-color);
            font-size: 0.9rem;
            padding-top: 4px;
        }
        .phone-flex-field {
            display: flex;
            gap: 8px;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="booking-progress-bar">
    <div class="progress-steps-container">
        <div class="progress-line-back"></div>
        <div class="progress-line-fill"></div>
        <div class="step-item active">
            <div class="step-number">1</div>
            <span>Thông tin khách hàng</span>
        </div>
        <div class="step-item">
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

            <div class="info-card-block relative-block">
                <div class="block-title"><i class="fa-solid fa-circle-user"></i> Người đặt phòng (Khách chính)</div>
                <div style="display: flex; gap: 15px; align-items: center; margin-top: 10px;">
                    <div style="font-size: 2.5rem; color: var(--primary-teal);"><i class="fa-regular fa-id-card"></i></div>
                    <div>
                        <p id="display-name" style="font-size: 1.1rem; font-weight: bold; margin: 0 0 5px 0;">Verdelle Mintha</p>
                        <p id="display-email" style="color: var(--sub-text); font-size: 0.9rem; margin: 0 0 3px 0;">VerdelleMintha@gmail.com</p>
                        <p id="display-phone" style="color: var(--sub-text); font-size: 0.9rem; margin: 0;"><i class="fa-solid fa-phone" style="font-size: 0.75rem;"></i> + 84 834178906</p>
                    </div>
                </div>
                <button id="btn-edit" class="btn-edit-trigger">Chỉnh sửa thông tin</button>
            </div>

            <div class="info-card-block">
                <div class="block-title">Yêu cầu đặc biệt</div>
                <p style="font-size: 0.8rem; color: var(--sub-text); margin: -10px 0 15px 0;">Chúng tôi sẽ cố gắng sắp xếp theo sở thích của quý khách</p>

                <label class="custom-checkbox-label">
                    <input type="checkbox" name="specialReq" value="highFloor">
                    <span style="font-size: 0.9rem;"><i class="fa-solid fa-layer-group" style="color: var(--primary-teal); width: 20px;"></i> Phòng tầng cao thoáng đãng</span>
                </label>

                <label class="custom-checkbox-label">
                    <input type="checkbox" name="specialReq" value="quietRoom">
                    <span style="font-size: 0.9rem;"><i class="fa-solid fa-volume-xmark" style="color: var(--primary-teal); width: 20px;"></i> Phòng yên tĩnh (Xa thang máy/lối đi)</span>
                </label>

                <label class="custom-checkbox-label">
                    <input type="checkbox" name="specialReq" value="earlyCheckin">
                    <span style="font-size: 0.9rem;"><i class="fa-solid fa-clock" style="color: var(--primary-teal); width: 20px;"></i> Yêu cầu nhận phòng sớm (Tùy thuộc tình trạng phòng)</span>
                </label>
            </div>

            <div class="policy-pink-box" style="border-left-color: #4caf50; background: var(--card-bg);">
                <div class="policy-title" style="color: #4caf50;"><i class="fa-solid fa-gift"></i> Quyền lợi phòng đi kèm miễn phí</div>
                <ul class="policy-list" style="margin-top: 10px;">
                    <li style="display: flex; justify-content: space-between; align-items: center;">
                        <span><i class="fa-solid fa-wifi" style="color: var(--primary-teal); margin-right: 8px;"></i> Kết nối Wifi tốc độ cao không giới hạn</span>
                        <span style="background: #2e7d32; color: #fff; font-size: 0.7rem; padding: 2px 8px; border-radius: 4px; font-weight: bold;">BAO GỒM</span>
                    </li>
                    <li style="display: flex; justify-content: space-between; align-items: center; margin-top: 8px;">
                        <span><i class="fa-solid fa-mug-hot" style="color: var(--primary-teal); margin-right: 8px;"></i> Buffet ăn sáng mỗi buổi sáng tại nhà hàng</span>
                        <span style="background: #2e7d32; color: #fff; font-size: 0.7rem; padding: 2px 8px; border-radius: 4px; font-weight: bold;">FREE</span>
                    </li>
                </ul>
            </div>

        </div>

        <div class="details-right-sidebar">

            <div class="booking-summary-dates">
                <div class="date-box-item">
                    <div class="date-box-label">Nhận phòng</div>
                    <div class="date-box-value">${not empty param.dateRange ? param.dateRange.split('-')[0].trim() : '01/06/2026'}</div>
                </div>
                <div style="color: var(--border-color); font-size: 1.2rem;"><i class="fa-solid fa-arrow-right-long"></i></div>
                <div class="date-box-item">
                    <div class="date-box-label">Trả phòng</div>
                    <div class="date-box-value">${not empty param.dateRange ? param.dateRange.split('-')[1].trim() : '05/06/2026'}</div>
                </div>
            </div>

            <div style="background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 12px; padding: 18px; margin-bottom: 20px;">
                <!-- ĐỔ DATA: Tên khách sạn -->
                <h5 style="font-size: 1.05rem; font-weight: bold; margin: 0 0 5px 0; color: var(--text-color);">${not empty selectedRoom.hotelName ? selectedRoom.hotelName : 'Verdelle Hotel'}</h5>
                <div style="color: #ffb300; font-size: 0.8rem; margin-bottom: 15px;">
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                </div>

                <!-- Chi tiết phòng preview -->
                <div style="background: var(--card-bg); padding: 1px; margin-bottom: 20px;">

                    <!-- Chi tiết phòng preview -->
                    <div style="display: flex; align-items: center; gap: 12px; padding: 10px; background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 8px; margin-bottom: 12px;">
                        <div style="width: 55px; height: 55px; background: #242424; border-radius: 6px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; overflow: hidden;">
                            <!-- ĐỔ DATA: Ảnh phòng động, nếu không có ảnh thì hiện icon mặt định -->
                            <c:choose>
                                <c:when test="${not empty selectedRoom.image}">
                                    <img src="${selectedRoom.image}" style="width: 100%; height: 100%; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <i class="fa-solid fa-image" style="color: var(--sub-text); font-size: 1.2rem;"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div>
                            <!-- ĐỔ DATA: Tên hạng phòng -->
                            <p style="font-size: 0.85rem; font-weight: bold; margin: 0 0 4px 0; color: var(--text-color);">${not empty selectedRoom.roomName ? selectedRoom.roomName : '1x Phòng chưa xác định'}</p>
                            <!-- ĐỔ DATA: Diện tích phòng -->
                            <p style="font-size: 0.75rem; color: var(--sub-text); margin: 0 0 2px 0;">Diện tích: ${not empty selectedRoom.area ? selectedRoom.area : 'N/A'} m²</p>
                            <!-- ĐỔ DATA: Loại giường -->
                            <p style="font-size: 0.75rem; color: var(--sub-text); margin: 0;">Gồm: ${not empty selectedRoom.bed ? selectedRoom.bed : 'N/A'}</p>
                        </div>
                    </div>

                    <div style="font-size: 0.8rem; color: #4caf50; margin-bottom: 15px; display: flex; align-items: center; gap: 6px;">
                        <i class="fa-solid fa-suitcase"></i> Có chỗ giữ hành lý
                    </div>

                    <div style="padding: 10px; background: rgba(76, 175, 80, 0.06); border: 1px solid rgba(76, 175, 80, 0.15); border-radius: 8px;">
                        <div style="font-size: 0.8rem; font-weight: bold; color: #4caf50; margin-bottom: 2px;">
                            <i class="fa-solid fa-thumbs-up"></i> Lựa chọn khách sạn tốt nhất
                        </div>
                        <div style="font-size: 0.75rem; color: var(--sub-text);">
                            Đánh giá trung bình của khách là 8,5
                        </div>
                    </div>
                </div>

                <!-- Khối tổng tiền chốt đơn -->
                <div class="price-final-card">
                    <div style="font-size: 0.85rem; color: var(--sub-text); margin-bottom: 5px;">Tổng chi phí dịch vụ</div>
                    <div class="price-row">
                        <span style="font-weight: bold; font-size: 1.1rem;">Giá cuối cùng:</span>
                        <span style="font-size: 1.5rem; font-weight: 900; color: #e65100;">
                            <c:choose>
                                <c:when test="${not empty selectedRoom.price}">
                                    <fmt:formatNumber value="${selectedRoom.price}" type="number" groupingUsed="true"/> đ
                                </c:when>
                                <c:otherwise>1.450.000 đ</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <form id="form-booking-submit" action="PaymentController" method="POST">
                        <input type="hidden" name="roomId" value="${selectedRoom.roomId}">
                        <input type="hidden" name="roomName" value="${selectedRoom.roomName}">
                        <input type="hidden" name="hotelName" value="${selectedRoom.hotelName}">
                        <input type="hidden" name="price" value="${selectedRoom.price}">
                        <input type="hidden" name="dateRange" value="${not empty dateRange ? dateRange : '01/06/2026 - 05/06/2026'}">
                        <input type="hidden" name="requiredRooms" value="${requiredRooms}">

                        <input type="hidden" id="hidden-customer-name" name="customerName" value="Verdelle Mintha">
                        <input type="hidden" id="hidden-customer-email" name="customerEmail" value="VerdelleMintha@gmail.com">
                        <input type="hidden" id="hidden-customer-phone" name="customerPhone" value="+ 84 834178906">

                        <input type="hidden" id="hidden-special-req" name="specialReqs" value="">

                        <button type="submit" class="btn-checkout-submit">
                            TIẾN HÀNH THANH TOÁN <i class="fa-solid fa-chevron-right"></i>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="modal-edit" class="custom-modal-overlay">
    <div id="modal-card" class="custom-modal-card">

        <div style="border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 20px;">
            <h3 style="font-size: 1.3rem; font-weight: bold; color: var(--primary-teal); margin: 0;">Thông tin hành khách chính</h3>
            <span style="font-size: 0.8rem; color: var(--sub-text);">Vui lòng kiểm tra kỹ ký tự để làm thủ tục check-in tại quầy dễ dàng.</span>
        </div>

        <div class="modal-grid">
            <div class="modal-input-wrapper">
                <label>Tên khách *</label>
                <input type="text" id="input-name" placeholder="Nhập tên đệm và tên chính">
            </div>

            <div class="modal-input-wrapper">
                <label>Quốc gia cư trú *</label>
                <input type="text" id="input-residence" value="Vietnam">
            </div>

            <div class="modal-input-wrapper">
                <label>Họ khách *</label>
                <input type="text" id="input-surname" placeholder="Nhập họ">
            </div>

            <div class="phone-flex-field">
                <div class="modal-input-wrapper" style="width: 80px; flex-shrink: 0; text-align: center;">
                    <label>Mã vùng</label>
                    <input type="text" value="+ 84" readonly style="text-align: center; font-weight: bold; color: var(--primary-teal);">
                </div>
                <div class="modal-input-wrapper" style="flex-grow: 1;">
                    <label>Số điện thoại *</label>
                    <input type="tel" id="input-phone" placeholder="Nhập số điện thoại di động">
                </div>
            </div>

            <div class="modal-input-wrapper modal-col-full">
                <label>Địa chỉ Email ID *</label>
                <input type="email" id="input-email" placeholder="Ví dụ: nickname@gmail.com">
            </div>
        </div>

        <div style="margin-top: 20px; display: flex; align-items: flex-start; gap: 10px;">
            <input type="checkbox" id="check-save" style="accent-color: var(--primary-teal); margin-top: 3px; cursor:pointer;">
            <label for="check-save" style="font-size: 0.8rem; color: var(--sub-text); line-height: 1.4; cursor:pointer; user-select:none;">
                Lưu thông tin khách hàng này vào tài khoản cá nhân để tăng tốc độ thanh toán điền form tự động cho các lần đặt phòng tiếp theo.
            </label>
        </div>

        <div style="margin-top: 25px; display: flex; justify-content: flex-end; gap: 12px;">
            <button type="button" id="btn-modal-close" style="padding: 10px 20px; background: #333; color: #fff; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">Đóng</button>
            <button type="button" id="btn-modal-save" style="padding: 10px 24px; background: var(--primary-teal); color: #000; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">Xác nhận lưu</button>
        </div>

    </div>
</div>

<script>
    const btnEdit = document.getElementById('btn-edit');
    const modalEdit = document.getElementById('modal-edit');
    const modalCard = document.getElementById('modal-card');
    const btnModalClose = document.getElementById('btn-modal-close');
    const btnModalSave = document.getElementById('btn-modal-save');

    const inputName = document.getElementById('input-name');
    const inputSurname = document.getElementById('input-surname');
    const inputPhone = document.getElementById('input-phone');
    const inputEmail = document.getElementById('input-email');

    const displayName = document.getElementById('display-name');
    const displayEmail = document.getElementById('display-email');
    const displayPhone = document.getElementById('display-phone');

    const hiddenName = document.getElementById('hidden-customer-name');
    const hiddenEmail = document.getElementById('hidden-customer-email');
    const hiddenPhone = document.getElementById('hidden-customer-phone');
    const hiddenSpecialReq = document.getElementById('hidden-special-req');
    const formSubmit = document.getElementById('form-booking-submit');

    // Bấm nút Chỉnh sửa -> Bung Popup Modal lên và đổ dữ liệu cũ vào các ô nhập
    btnEdit.addEventListener('click', (e) => {
        e.stopPropagation();

        const currentFullName = displayName.innerText.trim().split(' ');
        if (currentFullName.length >= 2) {
            inputSurname.value = currentFullName[0];
            inputName.value = currentFullName.slice(1).join(' ');
        } else {
            inputName.value = displayName.innerText;
            inputSurname.value = '';
        }

        inputEmail.value = displayEmail.innerText.trim();
        inputPhone.value = displayPhone.innerText.replace('+ 84 ', '').trim();

        modalEdit.classList.add('show');
    });

    // Hàm gom dữ liệu mới, cập nhật lên view giao diện và đóng popup
    function saveAndCloseModal() {
        const newFullName = `${inputSurname.value.trim()} ${inputName.value.trim()}`.trim();

        if (newFullName) displayName.innerText = newFullName;
        if (inputEmail.value.trim()) displayEmail.innerText = inputEmail.value.trim();
        if (inputPhone.value.trim()) displayPhone.innerText = `+ 84 ${inputPhone.value.trim()}`;

        modalEdit.classList.remove('show');
    }

    // Sự kiện khi bấm nút hủy/xác nhận bên trong Form
    btnModalSave.addEventListener('click', saveAndCloseModal);
    btnModalClose.addEventListener('click', () => modalEdit.classList.remove('show'));

    // CLICK RA NGOÀI KHUNG TRẮNG -> TỰ ĐỘNG LƯU VÀ ĐÓNG POPUP
    modalEdit.addEventListener('click', (e) => {
        if (!modalCard.contains(e.target)) {
            saveAndCloseModal();
        }
    });

    formSubmit.addEventListener('submit', function() {
        const checkedReqs = Array.from(document.querySelectorAll('input[name="specialReq"]:checked'))
            .map(cb => cb.value)
            .join('; ');
        hiddenSpecialReq.value = checkedReqs; // Ví dụ kết quả: "Phòng tầng cao; Phòng yên tĩnh"
    });
</script>

</body>
<footer>
    <jsp:include page="footer.jsp" />
</footer>
</html>