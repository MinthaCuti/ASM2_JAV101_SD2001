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

                <div id="success-message" style="display: none; color: #4caf50; font-size: 0.85rem; margin-bottom: 15px; font-weight: bold; text-align: center;">
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
                <a href="https://accounts.google.com/o/oauth2/auth?client_id=919945983221-5dd3uvtnqlquvtuj9vrqrj6jcqemo6us.apps.googleusercontent.com&redirect_uri=http://localhost:8080/ASM2_JAV101_SD2001_war/GoogleLoginController&response_type=code&scope=email%20profile" class="gg">
                    <i class="fa-brands fa-google"></i>
                </a>
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
            errorDiv.textContent = "Thông tin không chính xác!";
        } else if (errorType === 'userNotFound') {
            errorDiv.textContent = "Thông tin không chính xác!";
        } else {
            errorDiv.textContent = "Đăng nhập thất bại! Vui lòng thử lại.";
        }

        errorDiv.style.display = 'block'; // Hiện file thông báo lỗi lên
    }
    // Kiểm tra nếu đăng ký tài khoản thành công chuyển hướng về
    if (urlParams.has('status') && urlParams.get('status') === 'registerSuccess') {
        const successDiv = document.getElementById('success-message');
        successDiv.textContent = "Đăng ký tài khoản thành công! Mời cậu đăng nhập lại nhé.";
        successDiv.style.display = 'block'; // Hiện thông báo thành công
    }
</script>
</body>
</html>