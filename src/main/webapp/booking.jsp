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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/BookingStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                        <p class="price-breakdown">
                            Chi tiết tính: <fmt:formatNumber value="${selectedRoom.basePrice}" type="number" groupingUsed="true"/>đ x ${requiredRooms} phòng x ${totalNights} đêm
                        </p>
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
                        <input type="hidden" name="totalNights" value="${totalNights}">
                        <input type="hidden" name="basePrice" value="${selectedRoom.basePrice}">

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