<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Verdelle Hotel - Danh Sách Thành Viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/NavStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/AccountManagementStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FooterStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<jsp:include page="/header.jsp" />

<div class="table-container">
    <div class="table-title">
        <i class="fa-solid fa-address-book"></i> Danh Sách Thành Viên Hệ Thống
    </div>

    <table class="custom-table">
        <thead>
        <tr>
            <th style="width: 8%;"># ID</th>
            <th>Họ và Tên</th>
            <th style="width: 22%;">Số Điện Thoại</th>
            <th style="width: 15%;">Vai Trò</th>
            <th style="width: 30%;" colspan="3">Thao Tác Hệ Thống</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${empty list}">
                <tr>
                    <td colspan="5" style="color: #888888; padding: 25px;">
                        Hiện tại danh sách thành viên đang trống hoặc chưa được tải lên.
                    </td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="item" items="${list}">
                    <tr>
                        <td><strong>${item.id}</strong></td>

                        <td style="text-align: left; padding-left: 20px;">${item.firstName} ${item.lastName}</td>

                        <td><code>(${item.countryCode}) ${item.phoneNumber}</code></td>

                        <td>
                            <c:choose>
                                <c:when test="${item.role.trim().toLowerCase() == 'admin'}">
                                    <span class="badge badge-admin">Admin</span>
                                </c:when>
                                <c:when test="${item.role.trim().toLowerCase() == 'partner'}">
                                    <span class="badge badge-partner">Partner</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-customer">Customer</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <a href="${pageContext.request.contextPath}/userdetail?id=${item.id}" class="btn-action btn-detail">
                                <i class="fa-solid fa-circle-info"></i> Chi tiết
                            </a>
                        </td>

                        <td>
                            <a href="${pageContext.request.contextPath}/update?id=${item.id}" class="btn-action btn-update">
                                <i class="fa-regular fa-pen-to-square"></i> Sửa
                            </a>
                        </td>

                        <td>
                            <a href="${pageContext.request.contextPath}/delete?id=${item.id}"
                               class="btn-action btn-delete"
                               onclick="return confirm('Cậu có chắc chắn muốn ngắt hoạt động thành viên này hong...?');">
                                <i class="fa-regular fa-trash-can"></i> Xóa mềm
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
</body>
<footer>
    <jsp:include page="/footer.jsp" />
</footer>
</html>