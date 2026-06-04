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
                                    <div class="room-type-item" onclick="selectRoomType('Standard Room')">
                                        <span class="room-type-name">Standard Room</span>
                                        <span class="room-type-price">Giá gốc</span>
                                    </div>
                                    <div class="room-type-item" onclick="selectRoomType('Deluxe Room')">
                                        <span class="room-type-name">Deluxe Room</span>
                                        <span class="room-type-price">+500k</span>
                                    </div>
                                    <div class="room-type-item" onclick="selectRoomType('Executive Suite')">
                                        <span class="room-type-name">Executive Suite</span>
                                        <span class="room-type-price">+1.2M</span>
                                    </div>
                                    <div class="room-type-item" onclick="selectRoomType('Presidential VIP')">
                                        <span class="room-type-name">Presidential VIP</span>
                                        <span class="room-type-price">+3.5M</span>
                                    </div>
                                </div>
                            </div>

                            <div class="counter-row">
                                <div class="counter-label">
                                    <h6>Người lớn</h6>
                                    <p>18 tuổi trở lên</p>
                                </div>
                                <div class="counter-controls">
                                    <button type="button" class="btn-counter" onclick="changeCount('adult', -1)"><i class="fa-solid fa-minus"></i></button>
                                    <span id="count-adult">2</span>
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
                        <span class="realtime-badge-value cyan" id="priceRealtimeLabel">0đ trở lên</span>
                    </div>
                    <input type="range" id="priceRangeSlider" name="priceFilter" min="0" max="5000000" step="100000" value="0" style="width: 100%;">
                    <div class="ruler-container">
                        <ul class="ruler-ticks">
                            <li>0đ</li>
                            <li>1.2M</li>
                            <li>2.5M</li>
                            <li>3.7M</li>
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
    var bookingConfig = { room: 1, adult: 2, child: 0, roomType: 'Chọn loại phòng' };

    document.addEventListener("DOMContentLoaded", function() {
        // Cấu hình Litepicker
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
                        // Tính toán số ngày giữa 2 ngày được chọn
                        const timeDiff = Math.abs(date2.getTime() - date1.getTime());
                        const diffDays = Math.ceil(timeDiff / (1000 * 60 * 60 * 24));

                        // Cập nhật text hiển thị kèm số điểm tương ứng (+X điểm)
                        dateRangeInput.value = date1.format('DD/MM/YYYY') + ' - ' + date2.format('DD/MM/YYYY') + ' (' + diffDays + ' ngày) +' + diffDays + ' điểm';
                    });
                }
            });
        }

        updatePeopleInputText();

        // ĐỒNG BỘ HIỂN THỊ REALTIME CHO GIÁ TIỀN & SAO
        const priceSlider = document.getElementById('priceRangeSlider');
        const priceLabel = document.getElementById('priceRealtimeLabel');
        if(priceSlider && priceLabel) {
            priceSlider.addEventListener('input', function(e) {
                let val = e.target.value;
                let formattedPrice = new Intl.NumberFormat('vi-VN').format(val);
                priceLabel.textContent = formattedPrice + "đ trở lên";
            });
            let formattedPrice = new Intl.NumberFormat('vi-VN').format(priceSlider.value);
            priceLabel.textContent = formattedPrice + "đ trở lên";
        }

        const starSlider = document.getElementById('starFilterInput');
        const starLabel = document.getElementById('starRealtimeLabel');
        if(starSlider && starLabel) {
            starSlider.addEventListener('input', function(e) {
                let val = parseFloat(e.target.value);
                starLabel.textContent = val + " ★ trở lên";
            });
            starLabel.textContent = starSlider.value + " ★ trở lên";
        }

        // Xử lý gửi form tìm kiếm
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

        // Đóng mở Hamburger Menu và DarkMode
        // Đóng mở Hamburger Menu
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

        // KIỂM TRA TRẠNG THÁI DARK MODE KHI VỪA VÀO TRANG TRỦ
        if (localStorage.getItem('theme') === 'dark') {
            document.body.classList.add('dark-mode');
        } else {
            document.body.classList.remove('dark-mode');
        }

        // ĐỒNG BỘ KHI BẤM NÚT TOGGLE Ở TRÊN HEADER
        const themeToggleBtn = document.getElementById('themeToggleBtn');
        if (themeToggleBtn) {
            themeToggleBtn.addEventListener('click', function() {
                // Đoạn này để bổ trợ nếu nút gạt ở header cần kích hoạt cập nhật lại trạng thái class của trang chủ
                setTimeout(() => {
                    if (document.body.classList.contains('dark-mode')) {
                        localStorage.setItem('theme', 'dark');
                    } else {
                        localStorage.setItem('theme', 'light');
                    }
                }, 50);
            });
        }
    });

    // Quản lý trạng thái các ô Tìm kiếm gần đây & Số người
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

    // NGĂN CHẶN SỰ KIỆN CLICK BÊN TRONG DROPDOWN LÀM ĐÓNG BẢNG
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

    // Đóng các dropdown khi click ra ngoài màn hình
    document.addEventListener('click', function() {
        if(searchDropdown) searchDropdown.classList.remove('show');
        if(peopleDropdown) peopleDropdown.classList.remove('show');
        if(roomTypeContainer) roomTypeContainer.classList.remove('show');
    });

    function changeCount(type, amount) {
        let span = document.getElementById('count-' + type);
        if(!span) return;
        let current = parseInt(span.textContent);
        let next = current + amount;
        if(type === 'room' && (next < 1 || next > 9)) return;
        if(type === 'adult' && (next < 1 || next > 20)) return;
        if(type === 'child' && (next < 0 || next > 10)) return;

        span.textContent = next;
        bookingConfig[type] = next;
        updatePeopleInputText();

        // 💡 CHÈN THÊM LOGIC ĐỒNG BỘ Ô NHẬP TUỔI VÀO ĐÂY:
        if (type === 'child') {
            renderChildAgeInputs(next);
        }
    }

    function selectRoomType(name) {
        bookingConfig.roomType = name;
        if(roomTypeContainer) roomTypeContainer.classList.remove('show');
        updatePeopleInputText();
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

    // Các hàm slide chuyển động slider quảng cáo
    let currentSlide = 0;
    function slideNext() {
        const slider = document.getElementById('promoSlider');
        if(!slider) return;
        currentSlide = (currentSlide + 1) % 4;
        slider.style.transform = 'translateX(-' + (currentSlide * 25) + '%)';
    }
        const ageInput = document.getElementById('ageInput');

        // Biến dùng để ghi nhớ giá trị hợp lệ gần nhất của người dùng
        let lastValidValue = ageInput.value;

        ageInput.addEventListener('input', function() {
        // Nếu người dùng xóa hết chữ thì cho phép ô trống và lưu trạng thái trống
        if (this.value === "") {
        lastValidValue = "";
        return;
    }

        // Chuyển giá trị vừa gõ sang số nguyên
        const age = parseInt(this.value, 10);

        // RÀNG BUỘC GẮT: Nếu lớn hơn 17 hoặc nhỏ hơn 0
        if (age > 17 || age < 0) {
        // 1. Bật pop-up thông báo của trang web lên ngay lập tức
        alert("Độ tuổi của trẻ em phải từ 17 tuổi trở xuống!");

        // 2. Không nhận ký tự vừa gõ, khôi phục lại số hợp lệ trước đó
        this.value = lastValidValue;
    } else {
        // Nếu số gõ vào hợp lệ (từ 0 đến 17), cập nhật nó làm giá trị hợp lệ gần nhất
        lastValidValue = this.value;
    }
    });

    // Hàm tự động tạo ô nhập tuổi dựa trên số lượng trẻ em (Đã tích hợp chặn tuổi gắt)
    function renderChildAgeInputs(quantity) {
        const wrapper = document.getElementById('childAgeWrapper');
        const container = document.getElementById('childAgeInputsContainer');

        // Xóa sạch các ô nhập tuổi cũ trước khi tạo mới
        container.innerHTML = '';

        // Nếu số lượng trẻ em đưa vào bằng 0 hoặc nhỏ hơn, ẩn toàn bộ vùng này đi và dừng lại
        if (quantity <= 0) {
            wrapper.style.display = 'none';
            return;
        }

        // Nếu có trẻ em, hiện vùng nhập tuổi lên
        wrapper.style.display = 'block';

        // Vòng lặp sinh ra số lượng ô nhập tương ứng với số trẻ em
        for (let i = 1; i <= quantity; i++) {
            const group = document.createElement('div');
            group.style.margin = '8px 0';
            group.style.display = 'flex';
            group.style.alignItems = 'center';
            group.style.justifyContent = 'space-between';

            const label = document.createElement('span');
            label.textContent = 'Tuổi trẻ em thứ ' + i + ':';
            label.style.fontSize = '0.75rem';
            label.style.color = '#555';

            const input = document.createElement('input');
            input.type = 'number';
            input.className = 'age-input'; // Giữ nguyên class của cậu để ăn theo CSS có sẵn
            input.placeholder = '0 - 17';
            input.style.width = '100px';

            // Tính năng CHẶN TUỔI > 17 ngay lập tức khi gõ
            let lastValidValue = "";
            input.addEventListener('input', function() {
                if (this.value === "") {
                    lastValidValue = "";
                    return;
                }
                const age = parseInt(this.value, 10);
                if (age > 17 || age < 0) {
                    alert('Độ tuổi của trẻ em thứ ' + i + ' phải từ 17 tuổi trở xuống!');
                    this.value = lastValidValue; // Trả về số cũ hợp lệ
                } else {
                    lastValidValue = this.value; // Lưu lại số đúng gần nhất
                }
            });

            // Ghép nối giao diện
            group.appendChild(label);
            group.appendChild(input);
            container.appendChild(group);
        }
    }
    // Ví dụ logic nút Cộng (+) Trẻ em của cậu
    btnPlusChild.addEventListener('click', function() {
        childCount++; // Tăng số lượng trẻ em lên
        childDisplay.textContent = childCount; // Hiển thị số lượng ra màn hình (0, 1, 2...)

        // 💡 CHÈN THÊM DÒNG NÀY:
        renderChildAgeInputs(childCount);
    });

    // Ví dụ logic nút Trừ (-) Trẻ em của cậu
    btnMinusChild.addEventListener('click', function() {
        if (childCount > 0) {
            childCount--; // Giảm số lượng trẻ em xuống
            childDisplay.textContent = childCount;

            // 💡 CHÈN THÊM DÒNG NÀY:
            renderChildAgeInputs(childCount);
        }
    });
</script>
<c:if test="${not empty sessionScope.errorMessage}">
    <script>
        alert("${sessionScope.errorMessage}");
    </script>
    <%-- Hiển thị xong thì xóa thông báo đi để lần sau vào lại trang chủ không bị hiện lại --%>
    <c:remove var="errorMessage" scope="session" />
</c:if>
</body>
</html>