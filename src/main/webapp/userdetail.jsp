<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Chi Tiết Tài Khoản</title>
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
        }

        body.dark-mode {
            --bg-color: #343434;
            --card-bg: #1e1e1e;
            --text-color: #e5e7eb;
            --sub-text: #888888;
            --border-color: #333333;
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

        /* Khung chứa bo tròn profile card */
        .detail-container {
            max-width: 750px;
            width: 100%;
            margin: 50px auto;
            padding: 30px;
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            border-radius: 15px;
            box-sizing: border-box;
        }

        .detail-title {
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

        /* Grid chia layout giống Bootstrap nhưng custom mượt hơn */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(12, 12fr);
            gap: 20px;
        }

        .col-4 { grid-column: span 4; }
        .col-6 { grid-column: span 6; }
        .col-8 { grid-column: span 8; }
        .col-12 { grid-column: span 12; }

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

        /* Định dạng ô Input Readonly cho đẹp mắt */
        .form-control {
            width: 100%;
            padding: 11px 14px;
            background: #121212;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: #ffffff;
            box-sizing: border-box;
            font-size: 0.95rem;
            font-family: inherit;
        }

        .form-control[readonly], .form-control[disabled] {
            background: #141414;
            color: #cccccc;
            border-color: #222222;
            cursor: not-allowed;
        }

        code.phone-style {
            font-family: monospace;
            color: var(--primary-teal);
            font-size: 1rem;
        }

        /* Nút quay lại tinh tế */
        .btn-return {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 25px;
            padding: 12px 24px;
            background: transparent;
            border: 1px solid var(--primary-teal);
            color: var(--primary-teal);
            font-weight: bold;
            font-size: 0.95rem;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-return:hover {
            background: var(--primary-teal);
            color: #000000;
            box-shadow: 0 0 15px rgba(0, 188, 212, 0.4);
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="detail-container">
    <div class="detail-title">
        <i class="fa-solid fa-id-card"></i> Hồ Sơ Chi Tiết Tài Khoản
    </div>

    <div class="form-grid">

        <div class="form-group col-4">
            <label>Mã Tài Khoản (ID)</label>
            <input type="text" class="form-control" value="${user.id}" readonly>
        </div>

        <div class="form-group col-4">
            <label>Vai Trò / Quyền Hạn</label>
            <input type="text" class="form-control"
                   value="${user.role.trim().toLowerCase() == 'admin' ? 'Quản trị viên (Admin)' : (user.role.trim().toLowerCase() == 'partner' ? 'Đối tác (Partner)' : 'Khách hàng (Customer)')}" readonly>
        </div>

        <div class="form-group col-4">
            <label>Trạng Thái Hệ Thống</label>
            <input type="text" class="form-control" style="color: ${user.isActive ? '#4caf50' : '#f44336'};"
                   value="${user.isActive ? 'Đang Hoạt Động' : 'Đã Bị Khóa Mềm'}" readonly>
        </div>

        <div class="form-group col-6">
            <label>Tên (First Name)</label>
            <input type="text" class="form-control" value="${user.firstName}" readonly>
        </div>

        <div class="form-group col-6">
            <label>Họ (Last Name)</label>
            <input type="text" class="form-control" value="${user.lastName}" readonly>
        </div>

        <div class="form-group col-4">
            <label>Mã Quốc Gia</label>
            <input type="text" class="form-control" value="${user.countryCode}" readonly>
        </div>

        <div class="form-group col-8">
            <label>Số Điện Thoại Đăng Nhập</label>
            <input type="text" class="form-control" value="${user.phoneNumber}" readonly>
        </div>

        <div class="form-group col-12">
            <label>Địa Chỉ Email</label>
            <input type="email" class="form-control" value="${user.email}" readonly>
        </div>

        <div class="form-group col-12">
            <label>Mật Khẩu (Đã Mã Hóa Bảo Mật)</label>
            <input type="password" class="form-control" value="${user.password}" readonly>
        </div>
    </div>

    <div style="text-align: right;">
        <a href="${pageContext.request.contextPath}/quan-ly-tai-khoan" class="btn-return">
            <i class="fa-solid fa-arrow-left-long"></i> Quay Lại Danh Sách
        </a>
    </div>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>