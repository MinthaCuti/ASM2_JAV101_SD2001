<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - Verdelle Hotel</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/HomeStyle.css">
    <link rel="stylesheet" href="css/HeaderStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/litepicker/dist/css/litepicker.css">
    <script src="https://cdn.jsdelivr.net/npm/litepicker/dist/litepicker.js"></script>
</head>
<body class="home-body">
<div class="overlay">

    <jsp:include page="header.jsp" />

    <main class="main-content">
        <h1 class="welcome-title" style="letter-spacing: 2px;">
            Welcome ${not empty sessionScope.firstName ? sessionScope.firstName : 'User'}
        </h1>

        <div class="user-info-bar">
            <div class="info-item">Bậc khách hàng: <span class="highlight">N/A</span></div>
            <div class="divider-v"></div>
            <div class="info-item">Tích điểm: <span class="highlight">N/A</span></div>
        </div>

        <form action="SearchController" method="GET" id="searchForm">
            <div class="search-container" style="position: relative; z-index: 10;">

                <div class="search-box">
                    <i class="fa-solid fa-magnifying-glass search-icon" id="searchIcon" style="cursor: pointer;"></i>
                    <input type="text" id="searchInput" name="destination" placeholder="Nhập điểm du lịch hoặc tên khách sạn" autocomplete="off" value="${param.destination}">

                    <div class="search-dropdown" id="searchDropdown">
                        <div class="dropdown-section" id="recentSearchSection" style="display: none;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                <h4>Tìm kiếm gần đây</h4>
                                <span id="clearRecentBtn" style="font-size: 0.75rem; color: #ff4d4d; cursor: pointer; font-weight: 500;">Xóa tất cả</span>
                            </div>
                            <div class="dropdown-grid" id="recentSearchGrid"></div>
                            <hr class="dropdown-divider">
                        </div>

                        <div class="dropdown-section">
                            <h4>Các khách sạn nổi bật trong khu vực</h4>
                            <div class="dropdown-grid">
                                <div class="dropdown-item text-search-source" onclick="handleItemClick('Verdelle Premium Resort', 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=150', 'Vũng Tàu · ★★★★★')">
                                    <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=150" alt="Hotel 1">
                                    <div class="item-info">
                                        <h5>Verdelle Premium Resort</h5>
                                        <p>Vũng Tàu · ★★★★★</p>
                                    </div>
                                </div>
                                <div class="dropdown-item text-search-source" onclick="handleItemClick('Mintha Luxury Hotel', 'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=150', 'Đà Lạt · ★★★★')">
                                    <img src="https://images.unsplash.com/photo-1582719508461-905c673771fd?w=150" alt="Hotel 2">
                                    <div class="item-info">
                                        <h5>Mintha Luxury Hotel</h5>
                                        <p>Đà Lạt · ★★★★</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr class="dropdown-divider">

                        <div class="dropdown-section">
                            <h4>Các điểm đến ở Việt Nam</h4>
                            <div class="dropdown-grid">
                                <div class="dropdown-item text-search-source" onclick="handleItemClick('Nha Trang Beach', 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=150', 'Khánh Hòa')">
                                    <img src="https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=150" alt="Dest 1">
                                    <div class="item-info">
                                        <h5>Nha Trang Beach</h5>
                                        <p>Khánh Hòa</p>
                                    </div>
                                </div>
                                <div class="dropdown-item text-search-source" onclick="handleItemClick('Hồ Gươm Phố Cổ', 'https://images.unsplash.com/photo-1528127269322-539801943592?w=150', 'Hà Nội')">
                                    <img src="https://images.unsplash.com/photo-1528127269322-539801943592?w=150" alt="Dest 2">
                                    <div class="item-info">
                                        <h5>Hồ Gươm Phố Cổ</h5>
                                        <p>Hà Nội</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row-group" style="gap: 15px; margin-top: 15px;">
                    <div class="sub-input-box half-width" style="position: relative;">
                        <i class="fa-solid fa-calendar-days search-icon"></i>
                        <input type="text" id="dateRangeInput" name="dateRange" placeholder="Chọn ngày nhận - trả phòng" readonly style="width: 100%; padding: 15px 15px 15px 50px; border: none; border-radius: 15px; font-size: 1rem; box-shadow: inset 0 2px 4px rgba(0,0,0,0.05); outline: none; cursor: pointer;">
                    </div>

                    <div class="sub-input-box half-width" style="position: relative;" id="peopleSelectContainer">
                        <i class="fa-solid fa-users search-icon"></i>
                        <input type="text" id="peopleInput" name="guestsRooms" placeholder="Số người" readonly style="width: 100%; padding: 15px 15px 15px 50px; border: none; border-radius: 15px; font-size: 1rem; box-shadow: inset 0 2px 4px rgba(0,0,0,0.05); outline: none; cursor: pointer;">

                        <div class="people-dropdown" id="peopleDropdown">
                            <div class="counter-row">
                                <div class="counter-label">
                                    <h6>Phòng</h6>
                                    <a href="javascript:void(0)" class="room-type-link" id="toggleRoomTypeBtn">Chọn loại phòng <i class="fa-solid fa-chevron-down" style="font-size: 9px;"></i></a>
                                </div>
                                <div class="counter-controls">
                                    <button type="button" class="btn-counter" onclick="changeCount('room', -1)"><i class="fa-solid fa-minus"></i></button>
                                    <span id="count-room">1</span>
                                    <button type="button" class="btn-counter" onclick="changeCount('room', 1)"><i class="fa-solid fa-plus"></i></button>
                                </div>

                                <div class="room-type-container" id="roomTypeContainer">
                                    <div class="room-type-item" onclick="selectRoomType('Phòng Đơn')">
                                        <span class="room-type-name">Phòng Đơn</span>
                                    </div>
                                    <div class="room-type-item" onclick="selectRoomType('Phòng Đôi')">
                                        <span class="room-type-name">Phòng Đôi</span>
                                    </div>
                                    <div class="room-type-item" onclick="selectRoomType('Phòng VIP')">
                                        <span class="room-type-name">Phòng VIP (Family)</span>
                                    </div>
                                </div>
                            </div>

                            <div class="counter-row">
                                <div class="counter-label">
                                    <h6>Người lớn</h6>
                                    <p>18 tuổi trở lên (Bắt buộc)</p>
                                </div>
                                <div class="counter-controls">
                                    <button type="button" class="btn-counter" onclick="changeCount('adult', -1)"><i class="fa-solid fa-minus"></i></button>
                                    <span id="count-adult">1</span>
                                    <button type="button" class="btn-counter" onclick="changeCount('adult', 1)"><i class="fa-solid fa-plus"></i></button>
                                </div>
                            </div>

                            <div class="counter-row">
                                <div class="counter-label">
                                    <h6>Trẻ em</h6>
                                    <p>0-17 tuổi</p>
                                </div>
                                <div class="counter-controls">
                                    <button type="button" class="btn-counter" onclick="changeCount('child', -1)"><i class="fa-solid fa-minus"></i></button>
                                    <span id="count-child">0</span>
                                    <button type="button" class="btn-counter" onclick="changeCount('child', 1)"><i class="fa-solid fa-plus"></i></button>
                                </div>
                            </div>

                            <hr class="dropdown-divider">
                            <div id="childAgeWrapper" style="display: none; margin-top: 15px;">
                                <div class="age-hint" style="font-weight: bold; margin-bottom: 8px; font-size: 0.9rem;">Độ tuổi của trẻ em</div>
                                <div id="childAgeInputsContainer"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="filter-range" style="margin-top: 25px;">
                    <div class="realtime-badge-container">
                        <span class="realtime-title">Mức giá mỗi đêm:</span>
                        <span class="realtime-badge-value cyan" id="priceRealtimeLabel">0đ - 5.000.000đ</span>
                    </div>

                    <div class="dual-range-wrapper">
                        <div class="dual-range-track" id="priceTrack"></div>

                        <input type="range" id="minPriceSlider" name="minPriceFilter" min="0" max="5000000" step="100000" value="${not empty param.minPriceFilter ? param.minPriceFilter : '0'}" class="range-slider-input">

                        <input type="range" id="maxPriceSlider" name="maxPriceFilter" min="0" max="5000000" step="100000" value="${not empty param.maxPriceFilter ? param.maxPriceFilter : '5000000'}" class="range-slider-input">
                    </div>

                    <div class="ruler-container">
                        <ul class="ruler-ticks" style="display: flex; justify-content: space-between; padding: 0; margin: 0; list-style: none;">
                            <li>0đ</li>
                            <li>5.0M</li>
                        </ul>
                    </div>
                </div>

                <div class="filter-range" style="margin-top: 20px;">
                    <div class="realtime-badge-container">
                        <span class="realtime-title">Hạng sao khách sạn:</span>
                        <span class="realtime-badge-value" id="starRealtimeLabel">1 ★ trở lên</span>
                    </div>
                    <input type="range" id="starFilterInput" name="starFilter" min="1" max="5" step="0.5" value="1" style="width: 100%;">
                    <div class="ruler-container">
                        <ul class="ruler-ticks">
                            <li>1 ★</li>
                            <li>2 ★</li>
                            <li>3 ★</li>
                            <li>4 ★</li>
                            <li>5 ★</li>
                        </ul>
                    </div>
                </div>

                <button type="submit" class="btn-search-submit" style="margin-top: 15px;">Tìm</button>
            </div>
        </form>

        <c:if test="${not empty hotels}">
            <h2 class="section-title" style="margin-top: 40px;">Kết quả tìm kiếm khách sạn</h2>
            <div class="hotels-grid" id="homeHotelsSection" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; margin-bottom: 40px;">
                <c:forEach var="h" items="${hotels}">
                    <div class="hotel-card"
                         data-price="${h.minPrice}"
                         data-stars="${h.stars}"
                         data-single="${h.availableSingleRooms}"
                         data-double="${h.availableDoubleRooms}"
                         data-family="${h.availableFamilyRooms}"
                         style="background: var(--card-bg, #fff); padding: 15px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; gap: 10px;">

                        <div style="height: 180px; overflow: hidden; border-radius: 10px;">
                            <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400" alt="Hotel Img" style="width: 100%; height: 100%; object-fit: cover;">
                        </div>
                        <h4 style="margin: 5px 0 0 0; font-size: 1.1rem; font-weight: bold;">${h.name}</h4>
                        <p style="margin: 0; font-size: 0.85rem; color: #666;"><i class="fa-solid fa-location-dot"></i> ${h.city}</p>
                        <p style="margin: 0; font-size: 0.85rem; color: #ffa100;">${h.stars} ★</p>

                        <div style="display: flex; gap: 5px; flex-wrap: wrap; font-size: 0.75rem; margin: 5px 0;">
                            <span style="background: #e8f5e9; color: #2e7d32; padding: 2px 6px; border-radius: 4px;">Đơn: ${h.availableSingleRooms}</span>
                            <span style="background: #e3f2fd; color: #1565c0; padding: 2px 6px; border-radius: 4px;">Đôi: ${h.availableDoubleRooms}</span>
                            <span style="background: #fff3e0; color: #e65100; padding: 2px 6px; border-radius: 4px;">VIP: ${h.availableFamilyRooms}</span>
                        </div>

                        <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-weight: bold; color: #e65100; font-size: 1.1rem;">
                                <fmt:formatNumber value="${h.minPrice}" type="number" groupingUsed="true"/> đ
                            </span>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div id="homeEmptyMsg" style="display: none; background: var(--card-bg, #fff); padding: 40px; text-align: center; border-radius: 15px; margin-top: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 40px;">
                <p style="font-weight: bold; color: var(--text-color, #333); font-size: 1.1rem; margin-bottom: 8px;">Không có khách sạn nào đáp ứng bộ lọc của bạn.</p>
                <p style="font-size: 0.9rem; color: var(--sub-text, #666);">Vui lòng chọn loại phòng khác, hạ mức sao hoặc nới lỏng mức giá.</p>
            </div>
        </c:if>

        <div class="promo-container">
            <div class="promo-header">
                <h3>Chương trình khuyến mại chỗ ở</h3>
                <a href="SearchController?destination=&priceFilter=0&starFilter=1.0" class="view-all">Xem tất cả <i class="fa-solid fa-chevron-right" style="font-size: 10px;"></i></a>
            </div>

            <div class="promo-slider-wrapper">
                <div class="promo-slider" id="promoSlider">
                    <div class="promo-card"><img src="https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=600" alt="KM1"></div>
                    <div class="promo-card"><img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600" alt="KM2"></div>
                    <div class="promo-card"><img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=600" alt="KM3"></div>
                    <div class="promo-card"><img src="https://images.unsplash.com/photo-1582719508461-905c673771fd?w=600" alt="KM4"></div>
                </div>
                <button class="slider-btn" onclick="slideNext()"><i class="fa-solid fa-chevron-right"></i></button>
            </div>
        </div>

        <h2 class="section-title">Các điểm đến thu hút nhất Việt Nam</h2>
        <div class="destinations-grid">
            <div class="dest-card" onclick="handleItemClick('Vũng Tàu', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=150', 'Khu vực Miền Nam')" style="cursor: pointer;"><img src="https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=500" alt="Vũng Tàu"><p>Vũng Tàu</p></div>
            <div class="dest-card" onclick="handleItemClick('Đà Lạt', 'https://images.unsplash.com/photo-1589308078059-be1415eab4c3?w=150', 'Khu vực Tây Nguyên')" style="cursor: pointer;"><img src="https://images.unsplash.com/photo-1589308078059-be1415eab4c3?w=500" alt="Đà Lạt"><p>Đà Lạt</p></div>
            <div class="dest-card" onclick="handleItemClick('Nha Trang', 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=150', 'Khánh Hòa')" style="cursor: pointer;"><img src="https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=500" alt="Nha Trang"><p>Nha Trang</p></div>
            <div class="dest-card" onclick="handleItemClick('Hà Nội', 'https://images.unsplash.com/photo-1528127269322-539801943592?w=150', 'Thủ đô Hà Nội')" style="cursor: pointer;"><img src="https://images.unsplash.com/photo-1528127269322-539801943592?w=500" alt="Hà Nội"><p>Hà Nội</p></div>
        </div>
    </main>
    <jsp:include page="footer.jsp" />
</div>

<script>
    // Hàm lõi quét toàn bộ danh sách khách sạn dựa trên tất cả input hiện có
    function filterHomeHotels() {
        const hotelSection = document.getElementById('homeHotelsSection');
        if (!hotelSection) return; // Nếu danh sách chưa được truyền về thì bỏ qua không chạy

        const minPriceSlider = document.getElementById('minPriceSlider');
        const maxPriceSlider = document.getElementById('maxPriceSlider');
        const starSlider = document.getElementById('starFilterInput');

        const minPrice = minPriceSlider ? parseInt(minPriceSlider.value) : 0;
        const maxPrice = maxPriceSlider ? parseInt(maxPriceSlider.value) : 5000000;
        const minStars = starSlider ? parseFloat(starSlider.value) : 1.0;

        // Lấy cấu hình phòng đang chọn từ biến global bookingConfig
        const reqRoomType = bookingConfig.roomType;
        const reqRoomCount = bookingConfig.room;

        const cards = hotelSection.querySelectorAll('.hotel-card');
        let visibleCount = 0;

        cards.forEach(card => {
            const price = parseInt(card.getAttribute('data-price') || '0');
            const stars = parseFloat(card.getAttribute('data-stars') || '1');
            const single = parseInt(card.getAttribute('data-single') || '0');
            const double = parseInt(card.getAttribute('data-double') || '0');
            const family = parseInt(card.getAttribute('data-family') || '0');

            // 1. Kiểm tra khoảng giá slider
            const matchesPrice = (price >= minPrice && price <= maxPrice);

            // 2. Kiểm tra hạng sao khách sạn
            const matchesStars = (stars >= minStars);

            // 3. Kiểm tra loại phòng và số lượng phòng trống thực tế
            let matchesRoom = false;
            if (reqRoomType === 'Phòng Đơn') {
                matchesRoom = (single >= reqRoomCount);
            } else if (reqRoomType === 'Phòng Đôi') {
                matchesRoom = (double >= reqRoomCount);
            } else if (reqRoomType === 'Phòng VIP') {
                matchesRoom = (family >= reqRoomCount);
            } else {
                // Trường hợp chưa chọn cụ thể loại phòng ("Chọn loại phòng"), chỉ cần tổng số phòng trống đáp ứng đủ số lượng yêu cầu
                matchesRoom = ((single + double + family) >= reqRoomCount);
            }

            // Kết hợp toàn bộ điều kiện lọc
            if (matchesPrice && matchesStars && matchesRoom) {
                card.style.display = 'flex';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        // Điều khiển ẩn hiện khối thông báo trống như thiết kế trang hotel list
        const emptyMsg = document.getElementById('homeEmptyMsg');
        if (emptyMsg) {
            if (visibleCount === 0) {
                emptyMsg.style.display = 'block';
            } else {
                emptyMsg.style.display = 'none';
            }
        }
    }
</script>

<script>
    const minPriceSlider = document.getElementById('minPriceSlider');
    const maxPriceSlider = document.getElementById('maxPriceSlider');
    const priceRealtimeLabel = document.getElementById('priceRealtimeLabel');
    const priceTrack = document.getElementById('priceTrack');
    if (minPriceSlider && maxPriceSlider && priceTrack && priceRealtimeLabel) {
        const priceMaxLimit = 5000000;
        const priceMinGap = 100000;

        function formatCurrency(val) {
            return new Intl.NumberFormat('vi-VN').format(val) + "đ";
        }

        function updatePriceRange() {
            let minVal = parseInt(minPriceSlider.value);
            let maxVal = parseInt(maxPriceSlider.value);

            if (maxVal - minVal < priceMinGap) {
                if (this === minPriceSlider) {
                    minPriceSlider.value = maxVal - priceMinGap;
                    minVal = maxVal - priceMinGap;
                } else {
                    maxPriceSlider.value = minVal + priceMinGap;
                    maxVal = minVal + priceMinGap;
                }
            }

            priceRealtimeLabel.textContent = formatCurrency(minVal) + " - " + formatCurrency(maxVal);
            const percentLeft = (minVal / priceMaxLimit) * 100;
            const percentWidth = ((maxVal - minVal) / priceMaxLimit) * 100;

            priceTrack.style.left = percentLeft + "%";
            priceTrack.style.width = percentWidth + "%";

            // Kích hoạt hàm lọc danh sách phòng khi kéo thanh giá
            filterHomeHotels();
        }

        minPriceSlider.addEventListener('input', function() {
            minPriceSlider.style.zIndex = "3";
            maxPriceSlider.style.zIndex = "2";
            updatePriceRange.call(this);
        });
        maxPriceSlider.addEventListener('input', function() {
            maxPriceSlider.style.zIndex = "3";
            minPriceSlider.style.zIndex = "2";
            updatePriceRange.call(this);
        });
        minPriceSlider.addEventListener('mouseenter', () => { minPriceSlider.style.zIndex = "3"; maxPriceSlider.style.zIndex = "2"; });
        maxPriceSlider.addEventListener('mouseenter', () => { maxPriceSlider.style.zIndex = "3"; minPriceSlider.style.zIndex = "2"; });
        updatePriceRange.call(minPriceSlider);
    }

    // LOGIC CỐT LÕI: TỰ ĐỘNG CHIA PHÒNG - MAX 3 NGƯỜI/PHÒNG, BẮT BUỘC >= 1 NGƯỜI LỚN
    var bookingConfig = { room: 1, adult: 1, child: 0, roomType: 'Chọn loại phòng' };

    document.addEventListener("DOMContentLoaded", function() {
        const dateRangeInput = document.getElementById('dateRangeInput');
        if(dateRangeInput){
            new Litepicker({
                element: dateRangeInput,
                singleMode: false,
                numberOfMonths: 2,
                numberOfColumns: 2,
                minDate: new Date(),
                format: 'DD/MM/YYYY',
                dropdowns: {"minYear": 2026, "maxYear": null, "months": true, "years": true},
                setup: (picker) => {
                    picker.on('selected', (date1, date2) => {
                        const timeDiff = Math.abs(date2.getTime() - date1.getTime());
                        const diffDays = Math.ceil(timeDiff / (1000 * 60 * 60 * 24));
                        dateRangeInput.value = date1.format('DD/MM/YYYY') + ' - ' + date2.format('DD/MM/YYYY') + ' (' + diffDays + ' ngày) +' + diffDays + ' điểm';
                    });
                }
            });
        }

        updatePeopleInputText();

        const starSlider = document.getElementById('starFilterInput');
        const starLabel = document.getElementById('starRealtimeLabel');
        if(starSlider && starLabel) {
            starSlider.addEventListener('input', function(e) {
                let val = parseFloat(e.target.value);
                starLabel.textContent = val + " ★ trở lên";
                // Chạy hàm lọc khi dịch chuyển thanh chọn sao
                filterHomeHotels();
            });
            starLabel.textContent = starSlider.value + " ★ trở lên";
        }

        const searchInput = document.getElementById("searchInput");
        const searchForm = document.getElementById("searchForm");
        const searchIcon = document.getElementById("searchIcon");

        if (searchInput && searchForm) {
            searchInput.addEventListener("keypress", function(event) {
                if (event.key === "Enter") {
                    event.preventDefault();
                    var queryText = searchInput.value.trim();
                    if (queryText !== "") {
                        saveToRecent(queryText, "https://cdn-icons-png.flaticon.com/512/854/854878.png", "Điểm du lịch");
                    }
                    searchForm.submit();
                }
            });
        }
        if (searchIcon && searchForm) {
            searchIcon.addEventListener("click", function() {
                var queryText = searchInput.value.trim();
                if (queryText !== "") {
                    saveToRecent(queryText, "https://cdn-icons-png.flaticon.com/512/854/854878.png", "Điểm du lịch");
                }
                searchForm.submit();
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

        if (localStorage.getItem('theme') === 'dark') {
            document.body.classList.add('dark-mode');
        } else {
            document.body.classList.remove('dark-mode');
        }

        const themeToggleBtn = document.getElementById('themeToggleBtn');
        if (themeToggleBtn) {
            themeToggleBtn.addEventListener('click', function() {
                setTimeout(() => {
                    if (document.body.classList.contains('dark-mode')) {
                        localStorage.setItem('theme', 'dark');
                    } else {
                        localStorage.setItem('theme', 'light');
                    }
                }, 50);
            });
        }

        // Kích hoạt quét lọc danh sách khách sạn ngay khi tải xong trang Home
        filterHomeHotels();
    });

    var searchInput = document.getElementById('searchInput');
    var searchDropdown = document.getElementById('searchDropdown');
    var recentSection = document.getElementById('recentSearchSection');
    var recentGrid = document.getElementById('recentSearchGrid');
    var clearRecentBtn = document.getElementById('clearRecentBtn');
    var peopleInput = document.getElementById('peopleInput');
    var peopleDropdown = document.getElementById('peopleDropdown');
    var toggleRoomTypeBtn = document.getElementById('toggleRoomTypeBtn');
    var roomTypeContainer = document.getElementById('roomTypeContainer');

    if (searchInput && searchDropdown) {
        searchInput.addEventListener('click', function(e) {
            e.stopPropagation();
            renderRecentSearches();
            if(peopleDropdown) peopleDropdown.classList.remove('show');
            searchDropdown.classList.add('show');
        });
    }

    if (peopleInput && peopleDropdown) {
        peopleInput.addEventListener('click', function(e) {
            e.stopPropagation();
            if(searchDropdown) searchDropdown.classList.remove('show');
            peopleDropdown.classList.toggle('show');
        });
    }

    if (peopleDropdown) {
        peopleDropdown.addEventListener('click', function(e) {
            e.stopPropagation();
        });
    }

    if (toggleRoomTypeBtn && roomTypeContainer) {
        toggleRoomTypeBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            roomTypeContainer.classList.toggle('show');
        });
    }

    document.addEventListener('click', function() {
        if(searchDropdown) searchDropdown.classList.remove('show');
        if(peopleDropdown) peopleDropdown.classList.remove('show');
        if(roomTypeContainer) roomTypeContainer.classList.remove('show');
    });

    // LOGIC TĂNG GIẢM PHÒNG/NGƯỜI (AUTO-SCALING & VALIDATION)
    function changeCount(type, amount) {
        let span = document.getElementById('count-' + type);
        if(!span) return;

        let current = bookingConfig[type];
        let next = current + amount;

        // Bắt buộc ít nhất 1 người lớn
        if(type === 'adult' && (next < 1 || next > 20)) return;
        if(type === 'child' && (next < 0 || next > 10)) return;

        // Tính toán số phòng tối thiểu cần thiết (3 người / phòng)
        let tempAdult = type === 'adult' ? next : bookingConfig.adult;
        let tempChild = type === 'child' ? next : bookingConfig.child;
        let minRoomsNeeded = Math.ceil((tempAdult + tempChild) / 3);

        if(type === 'room') {
            if (next < minRoomsNeeded) {
                alert("Số lượng " + (tempAdult + tempChild) + " người yêu cầu tối thiểu " + minRoomsNeeded + " phòng (tối đa 3 người/phòng).");
                return;
            }
            if (next > 9) return;
        }

        // Áp dụng thay đổi
        bookingConfig[type] = next;

        // Tự động đẩy số lượng phòng lên nếu số người vượt quá sức chứa hiện tại
        if ((type === 'adult' || type === 'child') && bookingConfig.room < minRoomsNeeded) {
            bookingConfig.room = minRoomsNeeded;
            document.getElementById('count-room').textContent = bookingConfig.room;
        }

        span.textContent = bookingConfig[type];
        updatePeopleInputText();

        if (type === 'child') {
            renderChildAgeInputs(next);
        }

        // Chạy hàm lọc khi tăng giảm số phòng trống yêu cầu
        filterHomeHotels();
    }

    function selectRoomType(name) {
        bookingConfig.roomType = name;
        if(roomTypeContainer) roomTypeContainer.classList.remove('show');
        updatePeopleInputText();

        // Chạy hàm lọc khi người dùng đổi loại hạng phòng (Đơn/Đôi/VIP)
        filterHomeHotels();
    }

    function updatePeopleInputText() {
        if(!peopleInput) return;
        let typeStr = bookingConfig.roomType !== 'Chọn loại phòng' ? ' (' + bookingConfig.roomType + ')' : '';
        peopleInput.value = bookingConfig.room + ' Phòng' + typeStr + ', ' + bookingConfig.adult + ' Người lớn, ' + bookingConfig.child + ' Trẻ em';
    }

    function handleItemClick(name, img, desc) {
        if(searchInput) {
            searchInput.value = name;
        }
        saveToRecent(name, img, desc);
        if(searchDropdown) searchDropdown.classList.remove('show');
    }

    // LƯU LỊCH SỬ TÌM KIẾM AN TOÀN TRONG LOCALSTORAGE
    function saveToRecent(name, img, desc) {
        let list = JSON.parse(localStorage.getItem('recentSearches') || '[]');
        list = list.filter(item => item.name !== name);
        list.unshift({name: name, img: img, desc: desc});
        if(list.length > 4) list.pop();
        localStorage.setItem('recentSearches', JSON.stringify(list));
    }

    function renderRecentSearches() {
        let list = JSON.parse(localStorage.getItem('recentSearches') || '[]');
        if(!recentSection || !recentGrid) return;
        if(list.length === 0) {
            recentSection.style.display = 'none';
            return;
        }
        recentSection.style.display = 'block';
        recentGrid.innerHTML = '';
        list.forEach(item => {
            let div = document.createElement('div');
            div.className = 'dropdown-item';
            div.onclick = function() { handleItemClick(item.name, item.img, item.desc); };
            div.innerHTML = '<img src="' + item.img + '" alt="recent"><div class="item-info"><h5>' + item.name + '</h5><p>' + item.desc + '</p></div>';
            recentGrid.appendChild(div);
        });
    }

    if(clearRecentBtn) {
        clearRecentBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            localStorage.removeItem('recentSearches');
            if(recentSection) recentSection.style.display = 'none';
        });
    }

    let currentSlide = 0;
    function slideNext() {
        const slider = document.getElementById('promoSlider');
        if(!slider) return;
        currentSlide = (currentSlide + 1) % 4;
        slider.style.transform = 'translateX(-' + (currentSlide * 25) + '%)';
    }

    function renderChildAgeInputs(quantity) {
        const wrapper = document.getElementById('childAgeWrapper');
        const container = document.getElementById('childAgeInputsContainer');
        container.innerHTML = '';
        if (quantity <= 0) {
            wrapper.style.display = 'none';
            return;
        }
        wrapper.style.display = 'block';
        for (let i = 1; i <= quantity; i++) {
            const group = document.createElement('div');
            group.style.margin = '8px 0';
            group.style.display = 'flex';
            group.style.alignItems = 'center';
            group.style.justifyContent = 'space-between';

            const label = document.createElement('span');
            label.textContent = 'Tuổi trẻ em thứ ' + i + ':';
            label.style.fontSize = '0.75rem';
            label.style.color = 'var(--text-color)';

            const input = document.createElement('input');
            input.type = 'number';
            input.className = 'age-input';
            input.placeholder = '0 - 17';
            input.style.width = '100px';

            let lastValidValue = "";
            input.addEventListener('input', function() {
                if (this.value === "") {
                    lastValidValue = "";
                    return;
                }
                const age = parseInt(this.value, 10);
                if (age > 17 || age < 0) {
                    alert('Độ tuổi của trẻ em thứ ' + i + ' phải từ 17 tuổi trở xuống!');
                    this.value = lastValidValue;
                } else {
                    lastValidValue = this.value;
                }
            });
            group.appendChild(label);
            group.appendChild(input);
            container.appendChild(group);
        }
    }
</script>
<c:if test="${not empty sessionScope.errorMessage}">
    <script>
        alert("${sessionScope.errorMessage}");
    </script>
    <c:remove var="errorMessage" scope="session" />
</c:if>
</body>
</html>