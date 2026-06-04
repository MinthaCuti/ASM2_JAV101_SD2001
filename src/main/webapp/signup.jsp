<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sign In - Verdelle Hotel</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body> <div class="overlay">

    <nav class="navbar">
        <div class="logo">
            <span class="hotel-title">VERDELLE</span>
            <span class="hotel-sub">Hotel</span>
        </div>
        <ul class="nav-links">
            <li><a href="index.jsp">Trang chủ</a></li>
            <li><a href="#">Phòng</a></li>
            <li><a href="#">Liên hệ</a></li>
            <li><a href="index.jsp" class="btn-sign">Log In</a></li>
        </ul>
    </nav>

    <main class="main-content">
        <h1 class="welcome-title">Welcome to our website</h1>

        <div class="login-card">
            <h2>Sign in</h2>
            <form action="RegisterController" method="POST">

                <% if(request.getParameter("error") != null) { %>
                <% if("1".equals(request.getParameter("error"))) { %>
                <p style="color: #ff4d4d; font-size: 0.85rem; margin-bottom: 15px; font-weight: bold; text-align: center;">
                    Đăng ký thất bại! Số điện thoại đã được sử dụng.
                </p>
                <% } else if("passwordMismatch".equals(request.getParameter("error"))) { %>
                <p style="color: #ff4d4d; font-size: 0.85rem; margin-bottom: 15px; font-weight: bold; text-align: center;">
                    Mật khẩu xác nhận không trùng khớp! Vui lòng nhập lại.
                </p>
                <% } %>
                <% } %>

                <div class="floating-group">
                    <input type="text" id="ten" name="firstName" placeholder=" " required>
                    <label for="ten">Tên</label>
                </div>

                <div class="floating-group">
                    <input type="text" id="ho" name="lastName" placeholder=" " required>
                    <label for="ho">Họ</label>
                </div>

                <div class="floating-group">
                    <input type="password" id="password" name="password" placeholder=" " required>
                    <label for="password">Mật khẩu</label>
                </div>

                <div class="floating-group">
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder=" " required>
                    <label for="confirmPassword">Xác thực mật khẩu</label>
                </div>

                <div class="row-group">
                    <div class="floating-group country-box">
                        <select id="country" name="country" required>
                            <option value="+84" selected>+ 84</option>
                            <option value="+1">+ 1</option>
                            <option value="+81">+ 81</option>
                        </select>
                    </div>

                    <div class="floating-group phone-box">
                        <input type="tel" id="phone" name="phone" placeholder=" " required>
                        <label for="phone">Số điện thoại</label>
                    </div>
                </div>

                <button type="submit" class="btn-continue">Tiếp tục</button>

                <div class="terms-group">
                    <input type="checkbox" id="terms" required>
                    <label for="terms">
                        Tôi đồng ý với các điều khoản và chính sách bảo mật của Verdelle Hotel.
                    </label>
                </div>
            </form>
        </div>
    </main>
    <jsp:include page="footer.jsp" />
</div>
</body>
</html>