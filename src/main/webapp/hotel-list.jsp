<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Kết quả tìm kiếm - Verdelle Hotel</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HotelListStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/litepicker/dist/css/litepicker.css">
  <script src="https://cdn.jsdelivr.net/npm/litepicker/dist/litepicker.js"></script>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="top-filter-wrapper">
  <form action="SearchController" method="GET" id="searchFilterForm" class="filter-form-mini">
    <div class="mini-input-box">
      <i class="fa-solid fa-magnifying-glass"></i>
      <input type="text" name="destination" value="${not empty param.destination ? param.destination : searchKeyword}" placeholder="Bạn muốn đi đâu?">
    </div>
    <div class="mini-input-box">
      <i class="fa-solid fa-calendar-days"></i>
      <input type="text" id="datePickerMini" name="dateRange" value="${not empty param.dateRange ? param.dateRange : '01/06/2026 - 05/06/2026'}" placeholder="Chọn ngày nhận - trả phòng" readonly>
    </div>
    <div class="mini-input-box">
      <i class="fa-solid fa-users"></i>
      <input type="text" name="guestsRooms" value="${not empty param.guestsRooms ? param.guestsRooms : '1 Phòng - 2 Người lớn'}" placeholder="Số lượng phòng / người">
    </div>

    <input type="hidden" name="starFilter" id="hiddenStarFilter" value="${not empty param.starFilter ? param.starFilter : '1.0'}">

    <button type="submit" class="btn-update-mini">Cập nhật</button>
  </form>
</div>

<div class="main-content-container">

  <div class="promo-banner-pink">
    <div class="icon-percent">
      <i class="fa-solid fa-percent"></i>
    </div>
    <div>
      <h4 style="margin: 0 0 4px 0; color: #c62828; font-size: 1rem; font-weight: bold;">Phòng ngon giá tốt nhất:</h4>
      <c:choose>
        <c:when test="${not empty hotels}">
          <c:set var="topHotel" value="${hotels[0]}" />
          <div class="promo-meta-info">
            <span class="promo-hotel-tag">${topHotel.name}</span>
            <span style="color: #ffb300; font-size: 0.85rem;">
               <c:forEach begin="1" end="${topHotel.stars != null ? topHotel.stars : 5}">★</c:forEach>
            </span>
            <span style="font-size: 0.85rem; margin-left: 5px;">- Đặt ngay để nhận mức giá ưu đãi độc quyền hấp dẫn !!!</span>
          </div>
        </c:when>
        <c:otherwise>
          <p style="margin: 0; font-size: 0.88rem;">Hệ thống tự động ưu tiên hiển thị khách sạn rẻ nhất!</p>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <div class="billboard-container">
    <div class="billboard-led">
      <i class="fa-solid fa-circle-dot led-status-dot"></i>
      <span>KẾT QUẢ TÌM KIẾM KHU VỰC:</span>
      <span class="billboard-keyword">${not empty param.destination ? param.destination.toUpperCase() : (not empty searchKeyword ? searchKeyword.toUpperCase() : 'TẤT CẢ')}</span>
    </div>
  </div>

  <div class="split-results-layout">
    <aside class="left-map-sidebar">
      <div class="star-filter-card">
        <div class="filter-title">
          <i class="fa-solid fa-star" style="color: #ffb300;"></i> Lọc theo hạng sao
        </div>
        <div class="star-badge-status" id="starStatusLabel">
          Đang lọc: Từ ${not empty param.starFilter ? param.starFilter : '1.0'} ★ trở lên
        </div>
        <div class="star-range-container">
          <input type="range" class="star-slider" id="starRangeSlider" min="1.0" max="5.0" step="0.5" value="${not empty param.starFilter ? param.starFilter : '1.0'}">
          <div class="star-ticks">
            <span class="tick-label" onclick="setSliderValue(1.0)">1</span>
            <span class="tick-label" onclick="setSliderValue(2.0)">2</span>
            <span class="tick-label" onclick="setSliderValue(3.0)">3</span>
            <span class="tick-label" onclick="setSliderValue(4.0)">4</span>
            <span class="tick-label" onclick="setSliderValue(5.0)">5</span>
          </div>
        </div>
      </div>
    </aside>

    <section class="right-hotels-list" id="hotelsListSection">
      <c:if test="${empty hotels}">
        <div style="background: var(--card-bg); padding: 40px; text-align: center; border-radius: 8px;">
          <p>Không tìm thấy khách sạn nào phù hợp.</p>
        </div>
      </c:if>

      <c:forEach var="h" items="${hotels}">
        <div class="hotel-card" data-stars="${h.stars != null ? h.stars : 5.0}">
          <div class="hotel-card-img">
            <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400" alt="Hotel Photo">
            <div class="badge-sale">SALE</div>
          </div>
          <div class="hotel-card-info">
            <div>
              <h4 style="margin: 0 0 5px 0; font-size: 1.1rem; font-weight: bold;">${h.name}</h4>
              <div style="color: #ffb300; font-size: 0.8rem; margin-bottom: 8px;">
                <c:forEach begin="1" end="${h.stars != null ? h.stars : 5}">★</c:forEach>
              </div>
              <p style="margin: 0 0 8px 0; font-size: 0.85rem;">
                <i class="fa-solid fa-city" style="color: #00bcd4; width: 16px;"></i> Thành phố: <strong>${h.city}</strong>
              </p>

              <p style="margin: 0; font-size: 0.82rem; color: var(--sub-text); line-height: 1.6; display: flex; align-items: center; flex-wrap: wrap; gap: 8px;">
                <span>
                  <i class="fa-solid fa-location-dot" style="width: 16px;"></i> Địa chỉ: ${h.address}
                </span>
                <a href="https://www.google.com/maps/search/?api=1&query=${h.name} ${h.address}"
                   target="_blank"
                   rel="noopener noreferrer"
                   style="display: inline-flex; align-items: center; gap: 4px; background: #e0f7fa; color: #00838f; text-decoration: none; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; transition: 0.2s;"
                   onmouseover="this.style.background='#b2ebf2'"
                   onmouseout="this.style.background='#e0f7fa'">
                  <i class="fa-solid fa-map-marked-alt"></i> Xem bản đồ
                </a>
              </p>
            </div>
          </div>
          <div class="hotel-card-price-action">
            <span style="font-size: 0.75rem; color: var(--sub-text);">Giá mỗi đêm từ</span>
            <div style="margin: 3px 0 12px 0;">
              <span style="font-size: 1.2rem; font-weight: bold; color: #e65100;">
                <fmt:formatNumber value="${h.minPrice}" type="number" groupingUsed="true"/> đ
              </span>
            </div>

            <a href="SearchController?action=viewRooms&hotelId=${h.id}&dateRange=${not empty param.dateRange ? param.dateRange : '01/06/2026 - 05/06/2026'}&guestsRooms=${not empty param.guestsRooms ? param.guestsRooms : '1 Phòng - 2 Người lớn'}"
               style="background: #00bcd4; color: #fff; text-decoration: none; padding: 8px 0; width: 100%; text-align: center; border-radius: 4px; font-weight: bold; font-size: 0.85rem;">
              Xem phòng
            </a>
          </div>
        </div>
      </c:forEach>
    </section>
  </div>
</div>

<jsp:include page="footer.jsp" />

<script>
  function setSliderValue(val) {
    const slider = document.getElementById('starRangeSlider');
    if(slider) {
      slider.value = val;
      slider.dispatchEvent(new Event('input'));
    }
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
        dropdowns: {"minYear": 2026, "maxYear": null, "months": true, "years": true},
        setup: (picker) => {
          picker.on('selected', (date1, date2) => {
            datePickerInput.value = date1.format('DD/MM/YYYY') + ' - ' + date2.format('DD/MM/YYYY');
          });
        }
      });
    }

    const starSlider = document.getElementById('starRangeSlider');
    const starStatusLabel = document.getElementById('starStatusLabel');
    const hiddenStarFilter = document.getElementById('hiddenStarFilter');
    const hotelCards = document.querySelectorAll('.hotel-card');

    if(starSlider && starStatusLabel) {
      function applyStarFilter(targetValue) {
        starStatusLabel.textContent = `Đang lọc: Từ \${parseFloat(targetValue).toFixed(1)} ★ trở lên`;
        if(hiddenStarFilter) hiddenStarFilter.value = targetValue;

        hotelCards.forEach(card => {
          const cardStars = parseFloat(card.getAttribute('data-stars') || '5.0');
          if(cardStars >= parseFloat(targetValue)) {
            card.style.display = 'flex';
          } else {
            card.style.display = 'none';
          }
        });
      }

      starSlider.addEventListener('input', function(e) {
        applyStarFilter(e.target.value);
      });

      applyStarFilter(starSlider.value);
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
  });
</script>
</body>
</html>