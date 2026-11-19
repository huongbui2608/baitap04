<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Sửa Danh mục</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="/views/topbar.jsp"/>
<div class="container-sm">
  <div class="card">
    <h2>✏️ Sửa Danh mục</h2>
    <form action="${pageContext.request.contextPath}/admin/category/edit" method="post" enctype="multipart/form-data">
      <input type="hidden" name="id" value="${category.id}">
      <div class="form-group">
        <label>Tên danh mục *</label>
        <input type="text" name="catename" required value="${category.name}">
      </div>
      <div class="form-group">
        <label>Hình ảnh hiện tại</label>
        <c:choose>
          <c:when test="${not empty category.icon}">
            <div style="margin-bottom:10px;">
              <img src="${pageContext.request.contextPath}/image?fname=${category.icon}"
                   width="150" height="200" alt="Ảnh hiện tại"
                   style="border-radius:8px;object-fit:cover;display:block;margin-bottom:6px;">
              <small style="color:#666;">Chọn ảnh mới bên dưới để thay thế, hoặc để trống để giữ nguyên.</small>
            </div>
          </c:when>
          <c:otherwise>
            <p style="color:#999;font-size:.9rem;">Chưa có ảnh</p>
          </c:otherwise>
        </c:choose>
        <input type="file" name="icon" accept="image/*">
      </div>
      <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:8px;">
        <a href="${pageContext.request.contextPath}/admin/category/list" class="btn btn-secondary">Hủy</a>
        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>
