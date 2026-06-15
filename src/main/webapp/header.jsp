<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderStyle.css">
<nav class="navbar">
    <div class="logo" onclick="location.href='${pageContext.request.contextPath}/home.jsp'" style="cursor: pointer;">
        <span style="color: #fff; font-weight: bold; font-size: 1.4rem; letter-spacing: 1px;">VERDELLE</span>
        <span style="color: #00bcd4; font-size: 0.85rem; display: block; margin-top: -4px;">Hotel</span>
    </div>

    <ul style="display: flex; list-style: none; gap: 30px; margin: 0; align-items: center; padding: 0;">
        <li><a href="RoomController?action=list" style="color: #fff; text-decoration: none; font-size: 0.95rem;">Phòng</a></li>
        <li><a href="#" style="color: #fff; text-decoration: none; font-size: 0.95rem;">Liên hệ</a></li>

        <c:if test="${sessionScope.userRole == 'admin'}">
            <li class="admin-dropdown-container">
                <button class="admin-dropdown-btn" id="adminDropdownBtn">
                    Quản lý <i class="fa-solid fa-chevron-down" style="font-size: 0.7rem;"></i>
                </button>
                <ul class="admin-submenu" id="adminSubmenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/quan-ly-tai-khoan">
                            <i class="fa-solid fa-users-gear" style="color: #00bcd4;"></i> Quản lý người dùng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/quan-ly-hoa-hong">
                            <i class="fa-solid fa-comments-dollar" style="color: #ff9800;"></i> Quản lý hoa hồng
                        </a>
                    </li>
                </ul>
            </li>
        </c:if>

        <c:if test="${sessionScope.userRole == 'partner' || sessionScope.userRole == 'hotel partner'}">
            <li class="admin-dropdown-container">
                <button class="admin-dropdown-btn" id="partnerDropdownBtn" style="background-color: transparent; color: #fff; border: none; cursor: pointer; font-size: 0.95rem;">
                    Quản lý khách sạn <i class="fa-solid fa-chevron-down" style="font-size: 0.7rem;"></i>
                </button>
                <ul class="admin-submenu" id="partnerSubmenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/quan-ly-phong">
                            <i class="fa-solid fa-bed" style="color: #4caf50;"></i> Quản lý danh sách phòng
                        </a>
                    </li>
                </ul>
            </li>
        </c:if>

        <c:choose>
            <c:when test="${not empty sessionScope.firstName}">
                <li class="user-profile-header">
                    <a href="${pageContext.request.contextPath}/profile" class="nav-user-profile-link">
                        <img id="navAvatarPreview"
                             src="${not empty sessionScope.avatarUrl ? pageContext.request.contextPath.concat('/').concat(sessionScope.avatarUrl) : 'https://cdn-icons-png.flaticon.com/512/1144/1144760.png'}"
                             class="user-avatar-circle"
                             alt="Avatar">
                        <div style="font-size: 0.85rem; color: #fff;">
                            <strong>${sessionScope.firstName}</strong>
                        </div>
                    </a>
                </li>
            </c:when>
            <c:otherwise>
                <li class="user-profile-header">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="nav-user-profile-link">
                        <img src="https://cdn-icons-png.flaticon.com/512/1144/1144760.png" class="user-avatar-circle" alt="Default User">
                    </a>
                </li>
            </c:otherwise>
        </c:choose>

        <li class="hamburger-menu-container">
            <button class="hamburger-icon-btn" id="hamburgerBtn" aria-label="Menu">
                <i class="fa-solid fa-bars"></i>
            </button>
            <div class="hamburger-dropdown" id="hamburgerMenu">
                <a href="#">
                    <i class="fa-regular fa-comments" style="color: #00bcd4;"></i> Liên hệ CSKH
                </a>
                <a href="#">
                    <i class="fa-solid fa-gear" style="color: #7f8c8d;"></i> Cài đặt hệ thống
                </a>
                <div class="menu-item" id="themeToggleBtn">
                    <i class="fa-regular fa-moon" style="color: #f1c40f;"></i> Chế độ ban đêm
                    <i class="fa-solid fa-toggle-off toggle-theme-switch" id="toggleIcon" style="color: #ccc; font-size: 1.2rem;"></i>
                </div>
            </div>
        </li>
    </ul>
</nav>

<script>
    if (localStorage.getItem('theme') === 'dark') {
        document.body.classList.add('dark-mode');
    } else {
        document.body.classList.remove('dark-mode')
    }

    document.addEventListener("DOMContentLoaded", function() {
        const hamburgerBtn = document.getElementById('hamburgerBtn');
        const hamburgerMenu = document.getElementById('hamburgerMenu');
        const adminDropdownBtn = document.getElementById('adminDropdownBtn');
        const adminSubmenu = document.getElementById('adminSubmenu');

        // KHỞI TẠO BIẾN CHO PARTNER
        const partnerDropdownBtn = document.getElementById('partnerDropdownBtn');
        const partnerSubmenu = document.getElementById('partnerSubmenu');

        const themeToggleBtn = document.getElementById('themeToggleBtn');
        const toggleIcon = document.getElementById('toggleIcon');

        if (toggleIcon) {
            if (localStorage.getItem('theme') === 'dark') {
                toggleIcon.className = "fa-solid fa-toggle-on";
            } else {
                toggleIcon.className = "fa-solid fa-toggle-off";
            }
        }

        if (themeToggleBtn) {
            themeToggleBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const isDark = document.body.classList.toggle('dark-mode');
                if (isDark) {
                    localStorage.setItem('theme', 'dark');
                    if (toggleIcon) toggleIcon.className = "fa-solid fa-toggle-on";
                } else {
                    localStorage.setItem('theme', 'light');
                    if (toggleIcon) toggleIcon.className = "fa-solid fa-toggle-off";
                }
            });
        }

        if (adminDropdownBtn && adminSubmenu) {
            adminDropdownBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                adminSubmenu.classList.toggle('show');
                if (partnerSubmenu) partnerSubmenu.classList.remove('show'); // Đóng menu kia nếu đang mở
            });
        }

        // XỬ LÝ CLICK CHO NÚT QUẢN LÝ PARTNER
        if (partnerDropdownBtn && partnerSubmenu) {
            partnerDropdownBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                partnerSubmenu.classList.toggle('show');
                if (adminSubmenu) adminSubmenu.classList.remove('show'); // Đóng menu kia nếu đang mở
            });
        }

        if (hamburgerBtn && hamburgerMenu) {
            hamburgerBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                hamburgerMenu.classList.toggle('show');
                hamburgerMenu.classList.toggle('active');

                if (hamburgerMenu.classList.contains('show')) {
                    hamburgerMenu.style.display = 'block';
                } else {
                    hamburgerMenu.style.display = 'none';
                }
            });
        }

        document.addEventListener('click', function(e) {
            if (adminSubmenu && adminDropdownBtn && !adminDropdownBtn.contains(e.target)) {
                adminSubmenu.classList.remove('show');
            }
            // TỰ ĐỘNG ĐÓNG MENU PARTNER KHI BẤM RA NGOÀI MÀN HÌNH
            if (partnerSubmenu && partnerDropdownBtn && !partnerDropdownBtn.contains(e.target)) {
                partnerSubmenu.classList.remove('show');
            }
            if (hamburgerMenu && !hamburgerBtn.contains(e.target) && !hamburgerMenu.contains(e.target)) {
                hamburgerMenu.classList.remove('show', 'active');
                hamburgerMenu.style.display = 'none';
            }
        });
    });
</script>