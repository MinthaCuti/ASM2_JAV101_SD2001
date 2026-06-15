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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/litepicker/dist/css/litepicker.css">
    <script src="https://cdn.jsdelivr.net/npm/litepicker/dist/litepicker.js"></script>

    <style>
        /* =========================================================
           ✨ HỆ THỐNG CSS CHUẨN - FIX CÂN ĐỐI THANH FILTER & BẢNG
           ========================================================= */

        /* Nới rộng container một chút để bảng to tự nhiên vẫn nằm giữa đẹp mắt */
        .container {
            max-width: 1100px;
            width: 100%;
            margin: 40px auto;
            padding: 0 15px;
            box-sizing: border-box;
        }

        /* Khung bộ lọc chia theo Grid để cố định vị trí các cột */
        .filter-strip {
            display: grid;
            grid-template-columns: 1.2fr 1fr 1.4fr; /* Chia tỉ lệ khoảng cách 3 cột */
            background: var(--card-bg);
            padding: 20px;
            border-radius: 12px;
            border: 2px solid var(--border-color);
            margin-bottom: 25px;
            gap: 15px;
            align-items: start; /* Giúp các Label phía trên luôn thẳng hàng hàng ngang */
        }

        .filter-col {
            display: flex;
            flex-direction: column;
            gap: 8px;
            padding-right: 25px; /* SỬA LỖI ĐƯỜNG KẺ SÁT NÚT: Tạo khoảng cách rộng rãi trước đường kẻ */
            border-right: 1px solid var(--border-color);
        }

        .filter-col:last-child {
            border-right: none; /* Cột cuối cùng xóa đường kẻ phân cách */
            padding-right: 0;
        }

        .filter-label {
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--text-color);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .filter-input {
            width: 100%;
            height: 41px;
            padding: 10px 14px;
            border: 1px solid var(--border-color);
            background: var(--card-bg);
            color: var(--text-color);
            border-radius: 8px;
            font-size: 0.9rem;
            outline: none;
            box-sizing: border-box;
        }

        /* SỬA LỖI TRẠNG THÁI BỊ LỆCH: Đảm bảo cân bằng chiều dọc hoàn hảo */
        .checkbox-group {
            display: flex;
            gap: 15px;
            height: 41px; /* Chiều cao bằng khít với ô input của các cột bên cạnh */
            align-items: center; /* Căn giữa hai checkbox theo trục dọc */
        }

        .custom-checkbox {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.9rem;
            color: var(--text-color);
            cursor: pointer;
            line-height: 1;
        }

        .custom-checkbox input[type="checkbox"] {
            margin: 0; /* Xóa margin mặc định lỗi của trình duyệt */
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        .search-wrapper {
            display: flex;
            gap: 10px;
            width: 100%;
        }

        .btn-filter-submit {
            background-color: #1e62d0;
            color: white;
            border: none;
            padding: 0 18px;
            border-radius: 8px;
            font-weight: bold;
            font-size: 0.9rem;
            cursor: pointer;
            height: 41px;
            white-space: nowrap;
        }

        .btn-filter-submit:hover {
            background-color: #154fa3;
        }

        /* GIỮ NGUYÊN ĐỘ TO CỦA BẢNG VÀ CĂN GIỮA TRANG TRIỆT ĐỂ */
        .data-table {
            width: 100%;
            margin: 0 auto 25px auto; /* Luôn ép dòng căn giữa trang */
            border-collapse: collapse;
            background: var(--card-bg);
            table-layout: auto; /* Để trình duyệt tự tính toán phân bổ cột tối ưu */
        }

        .data-table th, .data-table td {
            border: 2px solid var(--border-color);
            padding: 12px 8px; /* Tối ưu nhẹ padding để bảng thon gọn */
            text-align: center;
            font-size: 0.88rem;
        }

        /* Cho phép text tiêu đề dài tự ngắt xuống hàng để thu hẹp độ rộng tổng của bảng */
        .data-table th {
            font-weight: 600;
            white-space: normal;
            vertical-align: middle;
        }

        /* Giữ nội dung dữ liệu (tiền, ngày tháng) gọn gàng trên 1 dòng */
        .data-table td {
            white-space: nowrap;
        }

        /* Đồng bộ cả tiêu đề và nội dung cột Tên Khách Hàng tự xuống dòng linh hoạt */
        .data-table th:nth-child(2),
        .data-table td:nth-child(2) {
            white-space: normal !important;
            min-width: 130px;
            max-width: 180px;
            word-break: break-word;
        }
    </style>
</head>
<body>

<div class="overlay">
    <jsp:include page="/header.jsp" />

    <div class="container">

        <div class="title-box">
            <h1>QUẢN LÝ HOA HỒNG</h1>
        </div>

        <div class="dashboard-grid">
            <div class="dash-card">
                <div class="card-label">Tổng hoa hồng nhận</div>
                <div class="card-value">
                    <%= request.getAttribute("totalReceived") != null ? String.format("%,.0f", (Double)request.getAttribute("totalReceived")) : "0" %> đ
                </div>
            </div>
            <div class="dash-card">
                <div class="card-label">Hoa hồng chờ thanh toán</div>
                <div class="card-value">
                    <%= request.getAttribute("totalPending") != null ? String.format("%,.0f", (Double)request.getAttribute("totalPending")) : "0" %> đ
                </div>
            </div>
            <div class="dash-card">
                <div class="card-label">Tỷ lệ hoa hồng trung bình</div>
                <div class="card-value">
                    <%= request.getAttribute("avgRate") != null ? request.getAttribute("avgRate") : "0%" %>
                </div>
            </div>
        </div>

        <%
            String[] selectedStatuses = request.getParameterValues("status");
            boolean isPaidChecked = false;
            boolean isPendingChecked = false;

            if (selectedStatuses != null) {
                for (String s : selectedStatuses) {
                    if ("Đã thanh toán".equals(s)) isPaidChecked = true;
                    if ("Chờ thanh toán".equals(s)) isPendingChecked = true;
                }
            } else if (request.getParameter("searchAction") == null) {
                isPaidChecked = true;
                isPendingChecked = true;
            }

            String dateRangeVal = request.getParameter("dateRange") != null ? request.getParameter("dateRange") : "";
            String bookingIdVal = request.getParameter("bookingId") != null ? request.getParameter("bookingId") : "";
        %>

        <form action="${pageContext.request.contextPath}/quan-ly-hoa-hong" method="GET" class="filter-strip">
            <input type="hidden" name="searchAction" value="filter">

            <div class="filter-col">
                <label class="filter-label" for="dateRangePicker"><i class="fa-regular fa-calendar-days"></i> Lọc theo ngày:</label>
                <input type="text" id="dateRangePicker" name="dateRange"
                       placeholder="Chọn khoảng ngày..."
                       value="<%= dateRangeVal %>" autocomplete="off" class="filter-input">
            </div>

            <div class="filter-col">
                <label class="filter-label"><i class="fa-solid fa-list-check"></i> Trạng thái:</label>
                <div class="checkbox-group">
                    <label class="custom-checkbox">
                        <input type="checkbox" name="status" value="Đã thanh toán" <%= isPaidChecked ? "checked" : "" %>>
                        <span>Đã thanh toán</span>
                    </label>
                    <label class="custom-checkbox">
                        <input type="checkbox" name="status" value="Chờ thanh toán" <%= isPendingChecked ? "checked" : "" %>>
                        <span>Chờ thanh toán</span>
                    </label>
                </div>
            </div>

            <div class="filter-col">
                <label class="filter-label" for="bookingIdInput"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm:</label>
                <div class="search-wrapper">
                    <input type="text" id="bookingIdInput" name="bookingId"
                           placeholder="Nhập mã VDxxxxxx..."
                           value="<%= bookingIdVal %>" class="filter-input"
                           pattern="VD\d{6}" title="Mã xác nhận đặt phòng phải có dạng chữ VD và kèm theo 6 số ngẫu nhiên">
                    <button type="submit" class="btn-filter-submit">Lọc dữ liệu</button>
                </div>
            </div>
        </form>

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
                <td style="font-weight: 600; color: #1e62d0;"><%= item.getBookingId() %></td>
                <td><%= item.getCustomerName() %></td>
                <td><%= sdf.format(item.getBookingDate()) %></td>
                <td><%= item.getPaymentDate() != null ? sdf.format(item.getPaymentDate()) : "-" %></td>
                <td><%= String.format("%,.0f", item.getTotalAmount()) %> đ</td>
                <td><%= (int)item.getCommissionRate() %>%</td>
                <td style="font-weight: 600; color: #2e7d32;"><%= String.format("%,.0f", item.getCommissionAmount()) %> đ</td>
                <td style="color: <%= "Đã thanh toán".equals(item.getStatus()) ? "#4ade80" : "#fb923c" %>; font-weight: bold; white-space: nowrap;">
                    <%= item.getStatus() %>
                </td>
                <td>
                    <a class="btn-action" style="padding: 5px 10px; color: #00bcd4; text-decoration: underline; cursor: pointer;" >Xem</a>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="9" style="text-align: center; padding: 30px; color: #888;">Không tìm thấy dữ liệu hoa hồng phù hợp với bộ lọc</td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <jsp:include page="/footer.jsp" />
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        new Litepicker({
            element: document.getElementById('dateRangePicker'),
            singleMode: false,
            numberOfMonths: 2,
            numberOfColumns: 2,
            format: 'DD/MM/YYYY',
            dropdowns: {
                "minYear": 2024,
                "maxYear": 2028,
                "months": true,
                "years": true
            },
            setup: (picker) => {
                picker.on('selected', (date1, date2) => {
                    document.getElementById('dateRangePicker').value =
                        date1.format('DD/MM/YYYY') + ' - ' + date2.format('DD/MM/YYYY');
                });
            }
        });
    });
</script>
</body>
</html>