<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Manager - Trang chủ</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="/views/topbar.jsp"/>
<div class="container">
  <div class="card welcome-card">
    <h1>📊 Trang Quản lý</h1>
    <p>Chào mừng <strong>${sessionScope.account.fullName}</strong> đến trang quản lý.</p>
    <span class="role-badge role-manager">Quản lý (Manager)</span>
  </div>
</div>
</body>
</html>
