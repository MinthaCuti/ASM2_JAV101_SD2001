<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chi tiết khách sạn & Phòng - Verdelle Hotel</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/RoomListStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/litepicker/dist/css/litepicker.css">
  <script src="https://cdn.jsdelivr.net/npm/litepicker/dist/litepicker.js"></script>
</head>
<body>

<jsp:include page="header.jsp" />

<c:set var="requiredRooms" value="1" />
<c:if test="${not empty param.guestsRooms}">
  <%-- Tách lấy từ đầu tiên trước khoảng trắng (chính là con số) --%>
  <c:set var="roomPart" value="${fn:split(param.guestsRooms, ' ')[0]}" />
  <c:set var="cleanedRooms" value="${fn:trim(roomPart).replaceAll('[^0-9]', '')}" />
  <c:if test="${not empty cleanedRooms}">
    <c:set var="requiredRooms" value="${cleanedRooms}" />
  </c:if>
</c:if>

<%-- THUẬT TOÁN TỰ ĐỘNG CHIA PHÒNG (TỐI ĐA 3 NGƯỜI / PHÒNG) --%>
<c:set var="totalGuests" value="2" />
<c:if test="${not empty param.guestsRooms}">
  <c:set var="lowerInput" value="${fn:toLowerCase(param.guestsRooms)}" />
  <c:set var="adults" value="0" />
  <c:set var="children" value="0" />

  <c:if test="${fn:contains(lowerInput, 'người lớn')}">
    <c:set var="adultPart" value="${fn:split(lowerInput, 'người lớn')[0]}" />
    <c:set var="adults" value="${fn:trim(adultPart).replaceAll('[^0-9]', '')}" />
  </c:if>

  <c:if test="${fn:contains(lowerInput, 'trẻ em')}">
    <c:set var="childPart" value="${fn:split(lowerInput, 'người lớn')[1]}" />
    <c:set var="childPart" value="${fn:split(childPart, 'trẻ em')[0]}" />
    <c:set var="children" value="${fn:trim(childPart).replaceAll('[^0-9]', '')}" />
  </c:if>

  <c:set var="adultsInt" value="${not empty adults ? adults : 0}" />
  <c:set var="childrenInt" value="${not empty children ? children : 0}" />
  <c:set var="totalGuests" value="${adultsInt + childrenInt}" />
</c:if>

<c:set var="calcRooms" value="${totalGuests / 3}" />
<fmt:formatNumber var="roundedRooms" value="${calcRooms + (calcRooms % 1 == 0 ? 0 : 0.5)}" pattern="#"/>
<c:set var="requiredRooms" value="${roundedRooms > 0 ? roundedRooms : 1}" />

<div class="top-filter-wrapper">
  <form action="SearchController" method="GET" id="searchFilterForm" class="filter-form-mini">
    <div class="mini-input-box">
      <i class="fa-solid fa-magnifying-glass"></i>
      <input type="text" name="destination" value="${not empty destination ? destination : param.destination}" placeholder="Bạn muốn đi đâu?">
    </div>
    <div class="mini-input-box">
      <i class="fa-solid fa-calendar-days"></i>
      <input type="text" id="datePickerMini" name="dateRange" value="${not empty param.dateRange ? param.dateRange : '01/06/2026 - 05/06/2026'}" readonly>
    </div>
    <div class="mini-input-box">
      <i class="fa-solid fa-users"></i>
      <input type="text" name="guestsRooms" value="${not empty param.guestsRooms ? param.guestsRooms : '1 Phòng - 2 Người lớn'}">
    </div>
    <button type="submit" class="btn-update-mini">Cập nhật</button>
  </form>
</div>

<div class="main-content-container">

  <div class="navigation-top-bar">
    <a href="SearchController?destination=${not empty destination ? destination : param.destination}&dateRange=${param.dateRange}&guestsRooms=${param.guestsRooms}" class="btn-back-to-list">
      <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách khách sạn
    </a>
  </div>

  <div class="hotel-header-info">
    <div class="hotel-title-row">
      <h2>${not empty selectedHotel.name ? selectedHotel.name : 'Verdelle Premium Resort & Hotel'}</h2>
      <div class="stars-orange">
        <c:forEach begin="1" end="${not empty selectedHotel.stars ? selectedHotel.stars : 5}">★</c:forEach>
      </div>
    </div>
    <div class="hotel-address-row">
      <span><i class="fa-solid fa-location-dot" style="color: #00bcd4;"></i> <span id="hotelAddressFull">Địa chỉ: ${not empty selectedHotel.address ? selectedHotel.address : 'Khu phố 4, Phường Hàm Tiến, Thành phố Phan Thiết, Bình Thuận'}</span></span>
      <a href="https://www.google.com/maps/search/?api=1&query=${not empty selectedHotel.name ? selectedHotel.name : 'Verdelle Hotel'}+${selectedHotel.address}" target="_blank" class="btn-view-map">
        <i class="fa-solid fa-map-marked-alt"></i> Xem bản đồ lớn
      </a>
    </div>
  </div>

  <div class="gallery-grid">
    <img class="gallery-item gallery-main" src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800" alt="Main view">
    <img class="gallery-item" src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400" alt="Pool view">
    <img class="gallery-item" src="https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=400" alt="Room view">
    <img class="gallery-item" src="https://images.unsplash.com/photo-1582719508461-905c673771fd?w=400" alt="Restaurant view">
    <img class="gallery-item" src="https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=400" alt="Mountain deck view">
  </div>

  <div class="details-tabs-nav">
    <button class="tab-btn active" onclick="switchTab(event, 'tongquan')">Tổng quan</button>
    <button class="tab-btn" onclick="switchTab(event, 'cosovatchat')">Cơ sở vật chất</button>
    <button class="tab-btn" onclick="switchTab(event, 'danhgia')">Đánh giá</button>
  </div>

  <div id="tongquan" class="tab-content-pane active">
    <div class="details-split-layout">

      <div class="details-left-content">

        <div class="info-card-block">
          <div class="block-title">Cơ sở vật chất</div>
          <div class="amenities-grid">
            <div class="amenity-item"><i class="fa-solid fa-check"></i> WiFi miễn phí</div>
            <div class="amenity-item"><i class="fa-solid fa-check"></i> Hồ bơi vô cực</div>
            <div class="amenity-item"><i class="fa-solid fa-check"></i> Chỗ đậu xe free</div>
            <div class="amenity-item"><i class="fa-solid fa-check"></i> Trung tâm Spa & Gym</div>
            <div class="amenity-item"><i class="fa-solid fa-check"></i> Nhà hàng buffet</div>
            <div class="amenity-item"><i class="fa-solid fa-check"></i> Quầy bar bãi biển</div>
          </div>
        </div>

        <div class="info-card-block">
          <div class="block-title">About us</div>
          <div class="about-text">
            Chào mừng bạn đến với <strong>${not empty selectedHotel.name ? selectedHotel.name : 'Verdelle Hotel'}</strong>. Tọa lạc tại vị trí đắc địa với tầm nhìn ôm trọn bờ biển thiên nhiên hoang sơ tuyệt đẹp, khách sạn của chúng tôi mang đến một không gian nghỉ dưỡng sang trọng bậc nhất đạt chuẩn quốc tế. Hệ thống phòng nghỉ được thiết kế tinh tế, kết hợp hài hòa giữa nét kiến trúc hiện đại và sự gần gũi với thiên nhiên nhiệt đới. Hãy để chúng tôi mang lại cho bạn và gia đình một kỳ nghỉ đáng nhớ với dịch vụ tận tâm và chuyên nghiệp hàng đầu.
          </div>
        </div>

        <div class="policy-pink-box">
          <div class="policy-title">Chính sách và Quy định</div>
          <ul class="policy-list">
            <li>Giờ check-in/check-out (14:00 - 12:00).</li>
            <li>Không thú cưng, hút thuốc.</li>
            <li>Không có chính sách hoàn tiền khi hủy phòng sát ngày.</li>
            <li>Xuất trình CCCD hoặc Hộ chiếu khi làm thủ tục.</li>
          </ul>
        </div>

      </div>

      <div class="details-right-sidebar">

        <div class="rating-summary-card">
          <div class="rating-header-score">
            <div>
              <span style="font-weight: bold; font-size: 1.1rem; display:block;">Đánh giá</span>
              <span style="font-size: 0.8rem; color: var(--sub-text);"><i class="fa-solid fa-circle-check" style="color: #00bcd4;"></i> Tuyệt vời</span>
            </div>
            <div class="score-badge">4.9 <i class="fa-solid fa-star" style="font-size: 0.85rem;"></i></div>
          </div>

          <div class="rating-sub-row">
            <div class="sub-score-tag">Vị trí: 4.9</div>
            <div class="sub-score-tag">Dịch vụ: 4.8</div>
            <div class="sub-score-tag">Giá cả: 4.7</div>
            <div class="sub-score-tag">Sạch sẽ: 4.9</div>
          </div>

          <div class="rating-lines-placeholder">
            <div class="line-p" style="width: 95%;"></div>
            <div class="line-p" style="width: 88%;"></div>
            <div class="line-p" style="width: 90%;"></div>
          </div>
          <a href="#" style="font-size: 0.8rem; color:#00bcd4; text-decoration:none; display:block; margin-top:10px; text-align:right;">Đọc mọi bài đánh giá</a>
        </div>

        <div class="map-placeholder-box">
          <div class="map-img-wrapper">
            <img src="https://images.unsplash.com/photo-1524661135-423995f22d0b?w=400" alt="Static Map Layout">
            <span>Bản đồ khu vực</span>
          </div>
          <div style="font-size: 0.85rem; font-weight: bold; margin-bottom: 8px;"><i class="fa-solid fa-location-dot" style="color:#ff1744;"></i> Điểm đánh giá vị trí tuyệt vời</div>

          <div style="font-size: 0.9rem; font-weight: 700; margin: 15px 0 8px 0; border-top: 1px dashed var(--border-color); padding-top: 10px;">
            <i class="fa-solid fa-map-location-dot" style="color: var(--primary-color);"></i> Các địa danh nổi tiếng gần đây
          </div>

          <div class="poi-list-advanced" id="poiDynamicContainer">
            <div class="poi-card-item">
              <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=150" class="poi-thumb" alt="place">
              <div class="poi-info">
                <h5 class="poi-title-text">Bãi biển trung tâm</h5>
                <p class="poi-address-text">Hàm Tiến, Phan Thiết</p>
                <div class="poi-meta-row">
                  <span class="poi-distance">Cách 200 m</span>
                  <a href="https://www.google.com/maps/search/?api=1&query=Bãi biển Hàm Tiến Phan Thiết" target="_blank" class="poi-map-link">Xem map</a>
                </div>
              </div>
            </div>

            <div class="poi-card-item">
              <img src="https://images.unsplash.com/photo-1563245372-f21724e3856d?w=150" class="poi-thumb" alt="place">
              <div class="poi-info">
                <h5 class="poi-title-text">Chợ đêm ẩm thực</h5>
                <p class="poi-address-text">Đại lộ Hùng Vương, Phan Thiết</p>
                <div class="poi-meta-row">
                  <span class="poi-distance">Cách 1.2 km</span>
                  <a href="https://www.google.com/maps/search/?api=1&query=Chợ đêm Phan Thiết" target="_blank" class="poi-map-link">Xem map</a>
                </div>
              </div>
            </div>
          </div>

          <a href="#" style="font-size: 0.8rem; color:#00bcd4; text-decoration:none; display:block; margin-top:12px; text-align:center; font-weight:600;">Xem thêm các địa danh khác</a>
        </div>

      </div>
    </div>
  </div>

  <div id="cosovatchat" class="tab-content-pane">
    <div class="info-card-block">
      <h3>Chi tiết dịch vụ tiện ích</h3>
      <p>Nội dung chi tiết về các trang thiết bị và gói tiện ích mở rộng đang được cập nhật...</p>
    </div>
  </div>

  <div id="danhgia" class="tab-content-pane">
    <div class="info-card-block">
      <h3>Phản hồi từ khách hàng</h3>
      <p>Tính năng đang trong quá trình phát triển. Vui lòng quay lại sau.</p>
    </div>
  </div>

  <div class="room-section-title">Chọn hạng phòng trống</div>

  <c:choose>
    <c:when test="${empty rooms}">
      <%-- NHÁNH PHÒNG GIẢ LẬP 1 --%>
      <div class="room-card">
        <div class="room-card-img">
          <img src="https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=500" alt="Deluxe Ocean">
        </div>
        <div class="room-card-details">
          <div>
            <h4 style="margin: 0 0 8px 0; font-size: 1.2rem; color: var(--text-color);">Phòng Deluxe Hướng Biển (Deluxe Ocean View)</h4>
            <p style="margin: 0 0 5px 0; font-size: 0.85rem; color: var(--sub-text);">
              <i class="fa-solid fa-maximize"></i> Diện tích: 35 m² | <i class="fa-solid fa-bed"></i> 1 Giường Đôi Cực Lớn
            </p>
            <p style="margin: 0; font-size: 0.85rem; color: #2e7d32;">
              <i class="fa-solid fa-mug-hot"></i> Đã bao gồm bữa ăn sáng miễn phí • Miễn phí hủy phòng
            </p>
          </div>
        </div>
        <div class="room-card-price-action">
          <span class="price-label">Giá tạm tính (${requiredRooms} phòng)</span>
          <div class="price-row">
            <span class="price-number">
              <fmt:formatNumber value="${1450000 * requiredRooms}" type="number" groupingUsed="true"/> đ
            </span>
            <form action="${pageContext.request.contextPath}/BookingController" method="POST" class="booking-form-action">
              <input type="hidden" name="roomId" value="1">
              <input type="hidden" name="roomName" value="Phòng Deluxe Hướng Biển (Deluxe Ocean View)">
              <input type="hidden" name="price" value="${1450000 * requiredRooms}">
              <input type="hidden" name="hotelName" value="${selectedHotel.name}">
              <input type="hidden" name="hotelStars" value="${selectedHotel.stars}">
              <input type="hidden" name="hotelAddress" value="${selectedHotel.address}">
              <input type="hidden" name="dateRange" value="${param.dateRange}">
              <input type="hidden" name="guestsRooms" value="${param.guestsRooms}">
              <input type="hidden" name="requiredRooms" value="${requiredRooms}">
              <button type="submit" class="btn-book-room-primary">Đặt phòng ngay</button>
            </form>
          </div>
        </div>
      </div>

      <%-- NHÁNH PHÒNG GIẢ LẬP 2 --%>
      <div class="room-card">
        <div class="room-card-img">
          <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?w=500" alt="Executive Suite">
        </div>
        <div class="room-card-details">
          <div>
            <h4 style="margin: 0 0 8px 0; font-size: 1.2rem; color: var(--text-color);">Phòng Executive Suite Cao Cấp</h4>
            <p style="margin: 0 0 5px 0; font-size: 0.85rem; color: var(--sub-text);">
              <i class="fa-solid fa-maximize"></i> Diện tích: 55 m² | <i class="fa-solid fa-bed"></i> 1 Giường King Size & Ban công riêng
            </p>
            <p style="margin: 0; font-size: 0.85rem; color: #2e7d32;">
              <i class="fa-solid fa-mug-hot"></i> Gói ưu đãi VIP: Ăn sáng + Cocktail Bar hoàng hôn miễn phí
            </p>
          </div>
        </div>
        <div class="room-card-price-action">
          <span class="price-label">Giá tạm tính (${requiredRooms} phòng)</span>
          <div class="price-row">
            <span class="price-number">
              <fmt:formatNumber value="${2890000 * requiredRooms}" type="number" groupingUsed="true"/> đ
            </span>
            <form action="${pageContext.request.contextPath}/BookingController" method="POST" class="booking-form-action">
              <input type="hidden" name="roomId" value="2">
              <input type="hidden" name="roomName" value="Phòng Executive Suite Cao Cấp">
              <input type="hidden" name="price" value="${2890000 * requiredRooms}">
              <input type="hidden" name="hotelName" value="${selectedHotel.name}">
              <input type="hidden" name="hotelStars" value="${selectedHotel.stars}">
              <input type="hidden" name="hotelAddress" value="${selectedHotel.address}">
              <input type="hidden" name="dateRange" value="${param.dateRange}">
              <input type="hidden" name="guestsRooms" value="${param.guestsRooms}">
              <input type="hidden" name="requiredRooms" value="${requiredRooms}">
              <button type="submit" class="btn-book-room-primary">Đặt phòng ngay</button>
            </form>
          </div>
        </div>
      </div>
    </c:when>
    <c:otherwise>
      <%-- NHÁNH ĐỔ DỮ LIỆU ĐỘNG TỪ DB --%>
      <c:forEach var="r" items="${rooms}">
        <div class="room-card">
          <div class="room-card-img">
            <img src="${not empty r.image ? r.image : 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=500'}" alt="Room Photo">
          </div>
          <div class="room-card-details">
            <div>
              <h4 style="margin: 0 0 8px 0; font-size: 1.2rem; color: var(--text-color);">${r.roomTypeName}</h4>
              <p style="margin: 0 0 5px 0; font-size: 0.85rem; color: var(--sub-text);">
                  <%-- FIX LỖI 1: Thay đổi r.size thành r.area trùng khớp với thuộc tính trong UserDAO --%>
                  <%-- FIX LỖI 2: Đổi r.bedInfo thành hiển thị số lượng người lớn/trẻ em tối đa để tránh lỗi trống dữ liệu --%>
                <i class="fa-solid fa-maximize"></i> Diện tích: ${r.area} m² | <i class="fa-solid fa-users"></i> Sức chứa tối đa: ${r.maxAdults} Người lớn & ${r.maxChildren} Trẻ em
              </p>
              <p style="margin: 0; font-size: 0.85rem; color: #2e7d32;">
                <i class="fa-solid fa-circle-check"></i> Tiện ích phòng: Điều hòa, Mini-bar, Két sắt an toàn, Máy sấy tóc.
              </p>
            </div>
          </div>
          <div class="room-card-price-action">
            <span style="font-size: 0.75rem; color: var(--sub-text);">Giá phòng:</span>
            <div style="margin: 3px 0 12px 0;">
              <span style="font-size: 1.25rem; font-weight: bold; color: #e65100;">
                <fmt:formatNumber value="${r.price * requiredRooms}" type="number" groupingUsed="true"/> đ
              </span>
            </div>
            <form action="${pageContext.request.contextPath}/BookingController" method="POST" style="width: 100%;">
              <input type="hidden" name="roomId" value="${r.id}">
              <input type="hidden" name="roomName" value="${r.roomTypeName}">
              <input type="hidden" name="price" value="${r.price * requiredRooms}">
              <input type="hidden" name="hotelName" value="${selectedHotel.name}">
              <input type="hidden" name="hotelStars" value="${selectedHotel.stars}">
              <input type="hidden" name="hotelAddress" value="${selectedHotel.address}">
              <input type="hidden" name="dateRange" value="${param.dateRange}">
              <input type="hidden" name="guestsRooms" value="${param.guestsRooms}">
              <input type="hidden" name="requiredRooms" value="${requiredRooms}">
              <button type="submit" class="btn-book-room">Đặt phòng</button>
            </form>
          </div>
        </div>
      </c:forEach>
    </c:otherwise>
  </c:choose>

</div>

<jsp:include page="footer.jsp" />

<script>
  function switchTab(evt, tabId) {
    const tabPanes = document.querySelectorAll('.tab-content-pane');
    tabPanes.forEach(pane => pane.classList.remove('active'));

    const tabBtns = document.querySelectorAll('.tab-btn');
    tabBtns.forEach(btn => btn.classList.remove('active'));

    document.getElementById(tabId).classList.add('active');
    evt.currentTarget.classList.add('active');
  }

  document.addEventListener("DOMContentLoaded", function() {
    const datePickerInput = document.getElementById('datePickerMini');
    if(datePickerInput){
      new Litepicker({
        element: datePickerInput,
        singleMode: false,
        numberOfMonths: 2,
        numberOfColumns: 2,
        minDate: new Date(),
        format: 'DD/MM/YYYY',
        dropdowns: {"minYear": 2026, "maxYear": null, "months": true, "years": true}
      });
    }

    const hamburgerBtn = document.getElementById('hamburgerBtn');
    const hamburgerMenu = document.getElementById('hamburgerMenu');
    if(hamburgerBtn && hamburgerMenu) {
      hamburgerBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        hamburgerMenu.classList.toggle('show');
      });
      document.addEventListener('click', function() {
        hamburgerMenu.classList.remove('show');
      });
    }

    const addressElement = document.getElementById('hotelAddressFull');
    const poiContainer = document.getElementById('poiDynamicContainer');

    if(addressElement && poiContainer) {
      const addressText = addressElement.textContent.toLowerCase();

      if(addressText.includes("đà lạt") || addressText.includes("da lat")) {
        poiContainer.innerHTML = `
           <div class="poi-card-item">
             <img src="https://images.unsplash.com/photo-1627139318991-38cb465f14d8?w=150" class="poi-thumb" alt="Hồ Xuân Hương">
             <div class="poi-info">
               <h5 class="poi-title-text">Hồ Xuân Hương</h5>
               <p class="poi-address-text">Trung tâm Phường 1, Đà Lạt</p>
               <div class="poi-meta-row">
                 <span class="poi-distance">Cách 450 m</span>
                 <a href="https://www.google.com/maps/search/?api=1&query=Hồ Xuân Hương Đà Lạt" target="_blank" class="poi-map-link">Xem map</a>
               </div>
             </div>
           </div>

           <div class="poi-card-item">
             <img src="https://images.unsplash.com/photo-1549488344-1f9b8d2bd1f3?w=150" class="poi-thumb" alt="Chợ đêm Đà Lạt">
             <div class="poi-info">
               <h5 class="poi-title-text">Chợ Đêm Đà Lạt</h5>
               <p class="poi-address-text">Đường Nguyễn Thị Minh Khai, Phường 1</p>
               <div class="poi-meta-row">
                 <span class="poi-distance">Cách 1.1 km</span>
                 <a href="https://www.google.com/maps/search/?api=1&query=Chợ đêm Đà Lạt" target="_blank" class="poi-map-link">Xem map</a>
               </div>
             </div>
           </div>

           <div class="poi-card-item">
             <img src="https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=150" class="poi-thumb" alt="Thung lũng tình yêu">
             <div class="poi-info">
               <h5 class="poi-title-text">Thung Lũng Tình Yêu</h5>
               <p class="poi-address-text">3-5-7 Đường Mai Anh Đào, Phường 8</p>
               <div class="poi-meta-row">
                 <span class="poi-distance">Cách 4.8 km</span>
                 <a href="https://www.google.com/maps/search/?api=1&query=Thung lũng tình yêu Đà Lạt" target="_blank" class="poi-map-link">Xem map</a>
               </div>
             </div>
           </div>
         `;
      }
    }
  });
</script>
</body>
</html>