<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Danh sách Danh mục</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="/views/topbar.jsp"/>
<div class="container">
  <div class="card">
    <h2>📂 Quản lý Danh mục</h2>
    <div class="bar">
      <form class="search-form" action="${pageContext.request.contextPath}/admin/category/list" method="get">
        <input type="text" name="keyword" placeholder="Tìm kiếm danh mục..." value="${keyword}">
        <button type="submit" class="btn btn-primary btn-sm">Tìm</button>
        <a href="${pageContext.request.contextPath}/admin/category/list" class="btn btn-secondary btn-sm">Xóa lọc</a>
      </form>
      <a href="${pageContext.request.contextPath}/admin/category/add" class="btn btn-success">+ Thêm mới</a>
    </div>
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th>STT</th>
            <th>Hình ảnh</th>
            <th>Tên danh mục</th>
            <th>Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty categories}">
              <tr><td colspan="4" style="text-align:center;color:#999;">Không có dữ liệu</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach items="${categories}" var="cat" varStatus="st">
                <tr>
                  <td>${st.count}</td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty cat.icon}">
                        <img src="${pageContext.request.contextPath}/image?fname=${cat.icon}" width="150" height="200" alt="${cat.name}" style="border-radius:8px;object-fit:cover;">
                      </c:when>
                      <c:otherwise>
                        <div style="width:150px;height:200px;background:#eee;border-radius:8px;display:flex;align-items:center;justify-content:center;color:#aaa;">No image</div>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td><strong>${cat.name}</strong></td>
                  <td>
                    <a href="${pageContext.request.contextPath}/admin/category/edit?id=${cat.id}" class="btn btn-secondary btn-sm">✏️ Sửa</a>
                    <a href="${pageContext.request.contextPath}/admin/category/delete?id=${cat.id}" class="btn btn-danger btn-sm"
                       onclick="return confirm('Bạn có chắc muốn xóa danh mục \"${cat.name}\" không?')">🗑️ Xóa</a>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
