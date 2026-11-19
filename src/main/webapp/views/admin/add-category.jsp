<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Thêm Danh mục</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="/views/topbar.jsp"/>
<div class="container-sm">
  <div class="card">
    <h2>➕ Thêm Danh mục mới</h2>
    <c:if test="${not empty alert}">
      <div class="alert alert-danger">${alert}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/admin/category/add" method="post" enctype="multipart/form-data">
      <div class="form-group">
        <label>Tên danh mục *</label>
        <input type="text" name="catename" required placeholder="Nhập tên danh mục">
      </div>
      <div class="form-group">
        <label>Hình ảnh (tùy chọn)</label>
        <input type="file" name="icon" accept="image/*">
      </div>
      <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:8px;">
        <a href="${pageContext.request.contextPath}/admin/category/list" class="btn btn-secondary">Hủy</a>
        <button type="submit" class="btn btn-primary">Thêm mới</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>
