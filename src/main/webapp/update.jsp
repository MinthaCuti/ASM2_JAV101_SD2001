<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Chỉnh Sửa Thành Viên</title>
    <link rel="stylesheet" href="css/HeaderStyle.css">
    <link rel="stylesheet" href="css/NavStyle.css">
    <link rel="stylesheet" href="css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-color: #0a0a0a;
            --card-bg: #1e1e1e;
            --text-color: #ffffff;
            --border-color: #2d2d2d;
            --primary-teal: #00bcd4;
            --btn-success: #4caf50;
            --btn-secondary: #555555;
        }

        html, body {
            margin: 0;
            padding: 0;
            font-family: system-ui, -apple-system, sans-serif;
            background-color: var(--bg-color) !important;
            color: var(--text-color);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Khung chứa form bo tròn sang xịn mịn */
        .form-container {
            max-width: 750px;
            width: 100%;
            margin: 50px auto;
            padding: 30px;
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            border-radius: 15px;
            box-sizing: border-box;
        }

        .form-title {
            font-size: 1.5rem;
            color: var(--primary-teal);
            margin-top: 0;
            margin-bottom: 25px;
            font-weight: bold;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 12px;
        }

        /* Grid chia bố cục ô nhập liệu */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 20px;
        }

        .col-4 {
            grid-column: span 4;
        }

        .col-6 {
            grid-column: span 6;
        }

        .col-8 {
            grid-column: span 8;
        }

        .col-12 {
            grid-column: span 12;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-size: 0.85rem;
            color: #888888;
            margin-bottom: 6px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Custom ô input và select box đồng bộ */
        .form-control, .form-select {
            width: 100%;
            padding: 11px 14px;
            background: #121212;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: #ffffff;
            box-sizing: border-box;
            font-size: 0.95rem;
            font-family: inherit;
            transition: all 0.3s;
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary-teal);
            box-shadow: 0 0 8px rgba(0, 188, 212, 0.2);
        }

        .form-control[readonly] {
            background: #141414;
            color: #888888;
            border-color: #222222;
            cursor: not-allowed;
        }

        /* Thiết kế cụm nút bấm điều hướng hành động */
        .btn-group {
            margin-top: 30px;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }

        .btn-custom {
            padding: 12px 24px;
            font-weight: bold;
            font-size: 0.95rem;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
        }

        .btn-submit {
            background: var(--btn-success);
            color: #ffffff;
        }

        .btn-submit:hover {
            background: #45a049;
            box-shadow: 0 0 15px rgba(76, 175, 80, 0.4);
        }

        .btn-cancel {
            background: transparent;
            border: 1px solid var(--btn-secondary);
            color: #cccccc;
        }

        .btn-cancel:hover {
            background: var(--btn-secondary);
            color: #ffffff;
        }
    </style>
</head>
<body>

<!-- 1. Nhúng Header của Verdelle Hotel -->
<jsp:include page="header.jsp"/>

<div class="form-container">
    <div class="form-title">
        <i class="fa-regular fa-pen-to-square"></i> Chỉnh Sửa Thông Tin Thành Viên
    </div>

    <!-- Form gửi POST tới đúng UpdateServlet qua bọc URL chính xác -->
    <form method="POST" action="${pageContext.request.contextPath}/update">
        <div class="form-grid">

            <div class="form-group col-4">
                <label>ID Thành Viên</label>
                <input type="text" class="form-control" name="id" value="${user.id}" readonly>
            </div>

            <div class="form-group col-8">
                <label>Vai Trò Hệ Thống (Role)</label>
                <select name="role" class="form-select">
                    <option value="customer" ${user.role.equalsIgnoreCase('customer') ? 'selected' : ''}>Khách hàng (Customer)</option>
                    <option value="partner" ${user.role.equalsIgnoreCase('partner') ? 'selected' : ''}>Đối tác (Partner)</option>
                    <option value="admin" ${user.role.equalsIgnoreCase('admin') ? 'selected' : ''}>Quản trị viên (Admin)</option>
                </select>
            </div>

            <div class="form-group col-6">
                <label>Tên (First name)</label>
                <input type="text" class="form-control" name="firstName" value="${user.firstName}" required>
            </div>

            <div class="form-group col-6">
                <label>Họ (Last name)</label>
                <input type="text" class="form-control" name="lastName" value="${user.lastName}" required>
            </div>

            <div class="form-group col-4">
                <label>Mã Quốc Gia</label>
                <input type="text" class="form-control" name="countryCode" value="${user.countryCode}"
                       placeholder="VD: +84" required>
            </div>

            <div class="form-group col-8">
                <label>Số Điện Thoại Đăng Nhập</label>
                <input type="text" class="form-control" name="phoneNumber" value="${user.phoneNumber}" required>
            </div>

            <div class="form-group col-12">
                <label>Địa Chỉ Email</label>
                <input type="email" class="form-control" name="email" value="${user.email}" required>
            </div>

            <div class="form-group col-12">
                <label>Mật Khẩu Mới</label>
                <input type="password" class="form-control" name="password" value="${user.password}" required>
            </div>
        </div>

        <!-- Cụm nút xác nhận hoặc hủy bỏ thao tác -->
        <div class="btn-group">
            <button type="submit" class="btn-custom btn-submit">
                <i class="fa-regular fa-floppy-disk"></i> Lưu Thay Đổi
            </button>
            <a href="${pageContext.request.contextPath}/quan-ly-tai-khoan" class="btn-custom btn-cancel">
                <i class="fa-solid fa-xmark"></i> Hủy Bỏ
            </a>
        </div>
    </form>
</div>

<jsp:include page="footer.jsp"/>

</body>
</html>