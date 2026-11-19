<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Danh sách Category (JPA)</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<jsp:include page="/views/topbar.jsp"/>
<div class="container">
  <div class="card">
    <h2>📂 Quản lý Category (JPA)</h2>
    <div style="margin-bottom: 20px;">
      <a href="<c:url value="/admin/category/add"/>" class="btn btn-success">+ Add Category</a>
    </div>
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th>STT</th>
            <th>Images</th>
            <th>Category name</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty listcate}">
              <tr><td colspan="5" style="text-align:center;color:#999;padding:24px;">Chưa có category nào</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach items="${listcate}" var="cate" varStatus="STT">
                <tr>
                  <td>${STT.index + 1}</td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty cate.images && (cate.images.startsWith('http://') || cate.images.startsWith('https://'))}">
                        <img height="150" width="200" src="${cate.images}" style="object-fit:cover;border-radius:8px;" />
                      </c:when>
                      <c:when test="${not empty cate.images}">
                        <img height="150" width="200" src="<c:url value="/image?fname=${cate.images}" />" style="object-fit:cover;border-radius:8px;" />
                      </c:when>
                      <c:otherwise>
                        <div style="width:200px;height:150px;background:#eee;border-radius:8px;display:flex;align-items:center;justify-content:center;color:#aaa;">No image</div>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td><strong>${cate.categoryname}</strong></td>
                  <td>
                    <c:choose>
                      <c:when test="${cate.status == 1}">
                        <span class="role-badge role-user">Hoạt động</span>
                      </c:when>
                      <c:otherwise>
                        <span class="role-badge role-admin">Khóa</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <a href="<c:url value='/admin/category/edit?id=${cate.categoryId}'/>" class="btn btn-secondary btn-sm">Sửa</a>
                    <a href="<c:url value='/admin/category/delete?id=${cate.categoryId}'/>" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc muốn xóa không?')">Xóa</a>
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
