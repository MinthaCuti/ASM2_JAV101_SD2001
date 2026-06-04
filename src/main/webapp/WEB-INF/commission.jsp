<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Commission" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Hoa Hồng - Verdelle Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/CommissionStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
</head>
<body>

<div class="overlay">
    <!-- NAVBAR HEADER -->
    <jsp:include page="/header.jsp" />

    <!-- MAIN CONTENT CONTAINER -->
    <div class="container">

        <!-- Tiêu đề -->
        <div class="title-box">
            <h1>QUẢN LÝ HOA HỒNG</h1>
        </div>

        <!-- 3 ô Dashboard thống kê số liệu tổng -->
        <div class="dashboard-grid">
            <div class="dash-card">
                <div class="card-label">Tổng hoa hồng nhận</div>
                <div class="card-value">
                    <%= request.getAttribute("totalReceived") != null ? String.format("%,.0f", (Double)request.getAttribute("totalReceived")) : "N/A" %>
                </div>
            </div>
            <div class="dash-card">
                <div class="card-label">Hoa hồng chờ thanh toán</div>
                <div class="card-value">
                    <%= request.getAttribute("totalPending") != null ? String.format("%,.0f", (Double)request.getAttribute("totalPending")) : "N/A" %>
                </div>
            </div>
            <div class="dash-card">
                <div class="card-label">Tỷ lệ hoa hồng trung bình</div>
                <div class="card-value">
                    <%= request.getAttribute("avgRate") != null ? request.getAttribute("avgRate") : "N/A%" %>
                </div>
            </div>
        </div>

        <!-- Thanh bộ lọc thông tin -->
        <div class="filter-strip">
            <div class="filter-col">
                <div class="filter-label">Lọc theo:</div>
                <div>[day - day]</div>
            </div>
            <div class="filter-col">
                <div class="filter-label">Trạng thái:</div>
                <div>Tất cả/ Đã thanh toán/ Chờ</div>
            </div>
            <div class="filter-col">
                <div class="filter-label">Tìm kiếm:</div>
                <div>[Booking ID]</div>
            </div>
        </div>

        <!-- Bảng danh sách chi tiết -->
        <table class="data-table">
            <thead>
            <tr>
                <th>Mã Booking</th>
                <th>Tên Khách Hàng</th>
                <th>Ngày Đặt</th>
                <th>Ngày Thanh Toán</th>
                <th>Tổng Tiền</th>
                <th>Tỷ Lệ Commission</th>
                <th>Hoa Hồng Nhận</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Commission> list = (List<Commission>) request.getAttribute("commissionList");
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                if (list != null && !list.isEmpty()) {
                    for (Commission item : list) {
            %>
            <tr>
                <td style="font-weight: 600;"><%= item.getBookingId() %></td>
                <td><%= item.getCustomerName() %></td>
                <td><%= sdf.format(item.getBookingDate()) %></td>
                <td><%= item.getPaymentDate() != null ? sdf.format(item.getPaymentDate()) : "-" %></td>
                <td><%= String.format("%,.0f", item.getTotalAmount()) %></td>
                <td><%= (int)item.getCommissionRate() %>%</td>
                <td style="font-weight: 600;"><%= String.format("%,.0f", item.getCommissionAmount()) %></td>
                <td style="color: <%= "Đã thanh toán".equals(item.getStatus()) ? "#4ade80" : "#fb923c" %>; font-weight: bold; white-space: nowrap;">
                    <%= item.getStatus() %>
                </td>
                <td>
                    <a class="btn-action" style="padding: 5px 10px; color: #00bcd4; text-decoration: underline" >Xem</a>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="9">Không có dữ liệu hiển thị</td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <jsp:include page="/footer.jsp" />
</div>
</body>
</html>