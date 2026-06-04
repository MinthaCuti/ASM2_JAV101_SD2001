<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - Verdelle Hotel</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/FooterStyle.css">
</head>
<body>
<div class="overlay">

    <nav class="navbar">
        <div class="logo">
            <span class="hotel-title">VERDELLE</span>
            <span class="hotel-sub">Hotel</span>
        </div>
        <ul class="nav-links">
            <li><a href="index.jsp" class="active">Trang chủ</a></li>
            <li><a href="#">Phòng</a></li>
            <li><a href="#">Liên hệ</a></li>
            <li><a href="signup.jsp" class="btn-sign">Sign In</a></li>
        </ul>
    </nav>

    <main class="main-content">
        <h1 class="welcome-title">Welcome to our website</h1>

        <div class="login-card">
            <h2>Log in</h2>
            <form action="LoginController" method="POST">

                <div id="error-message" style="display: none; color: #ff4d4d; font-size: 0.85rem; margin-bottom: 15px; font-weight: bold; text-align: center;">
                </div>

                <div class="input-group">
                    <i class="fa-solid fa-phone icon"></i>
                    <input type="text" placeholder="Phone Number" name="phone" required>
                </div>

                <div class="input-group">
                    <i class="fa-solid fa-lock icon"></i>
                    <input type="password" placeholder="Password" name="password">
                </div>

                <button type="submit" class="btn-login">LOGIN</button>
                <a href="#" class="forgot-pwd">Forgot Password?</a>
            </form>

            <p class="signup-text">Don't have an account? <a href="signup.jsp">Sign Up</a></p>
            <div class="divider"><hr><span>OR</span><hr></div>
            <p class="social-text">Sign up with Social Networks</p>
            <div class="social-icons">
                <a href="#" class="fb"><i class="fa-brands fa-facebook-f"></i></a>
                <a href="#" class="gg"><i class="fa-brands fa-google"></i></a>
                <a href="#" class="tw"><i class="fa-brands fa-twitter"></i></a>
            </div>
        </div>
    </main>
    <jsp:include page="footer.jsp" />
</div>

<script>
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('error')) {
        const errorType = urlParams.get('error');
        const errorDiv = document.getElementById('error-message');

        if (errorType === 'wrongPassword') {
            errorDiv.textContent = "Mật khẩu nhập vào không chính xác!";
        } else if (errorType === 'userNotFound') {
            errorDiv.textContent = "Số điện thoại không tồn tại trong hệ thống!";
        } else {
            errorDiv.textContent = "Đăng nhập thất bại! Vui lòng thử lại.";
        }

        errorDiv.style.display = 'block'; // Hiện file thông báo lỗi lên
    }
</script>
</body>
</html>