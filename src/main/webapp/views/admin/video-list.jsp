<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Quản lý Video - Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    .admin-container {
      max-width: 1200px;
      margin: 24px auto;
      padding: 0 16px;
    }
    .thumb-sm {
      width: 72px;
      height: 48px;
      object-fit: cover;
      border-radius: 4px;
      background: #eee;
    }
    .table-responsive {
      overflow-x: auto;
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    }
    .action-btns {
      display: flex;
      gap: 6px;
    }
    .btn-sm {
      padding: 6px 12px;
      font-size: 13px;
      border-radius: 6px;
      text-decoration: none;
      font-weight: 600;
    }
    .btn-edit { background: #3b82f6; color: #fff; }
    .btn-del { background: #ef4444; color: #fff; }
    .btn-view { background: #10b981; color: #fff; }
  </style>
</head>
<body>
<jsp:include page="/views/topbar.jsp"/>

<div class="admin-container">
  <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px;">
    <div>
      <h1 style="font-size: 24px; color: #111827;">🎬 Quản lý Danh sách Video</h1>
      <p style="color: #6b7280; font-size: 14px;">Quản trị video (CRUD), upload poster và video với @MultipartConfig</p>
    </div>
    <div style="display: flex; gap: 12px;">
      <a href="${pageContext.request.contextPath}/admin/video/add" class="btn btn-primary">➕ Thêm Video Mới</a>
      <a href="${pageContext.request.contextPath}/admin/categories" class="btn" style="background:#4b5563; color:#fff;">📁 Quản lý Category</a>
    </div>
  </div>

  <div class="table-responsive">
    <table class="table" style="width: 100%; border-collapse: collapse;">
      <thead>
        <tr style="background: #f9fafb; text-align: left; border-bottom: 2px solid #e5e7eb;">
          <th style="padding: 12px 16px;">Poster</th>
          <th style="padding: 12px 16px;">Mã Video</th>
          <th style="padding: 12px 16px;">Tiêu đề</th>
          <th style="padding: 12px 16px;">Danh mục</th>
          <th style="padding: 12px 16px;">Lượt xem</th>
          <th style="padding: 12px 16px;">Người đăng</th>
          <th style="padding: 12px 16px;">Trạng thái</th>
          <th style="padding: 12px 16px; text-align: center;">Thao tác</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="v" items="${videoList}">
          <tr style="border-bottom: 1px solid #f3f4f6;">
            <td style="padding: 12px 16px;">
              <c:choose>
                <c:when test="${v.poster != null && (v.poster.startsWith('http://') || v.poster.startsWith('https://'))}">
                  <img src="${v.poster}" alt="${v.title}" class="thumb-sm">
                </c:when>
                <c:when test="${v.poster != null && !v.poster.isEmpty()}">
                  <img src="${pageContext.request.contextPath}/image?fname=${v.poster}" alt="${v.title}" class="thumb-sm">
                </c:when>
                <c:otherwise>
                  <img src="https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600" class="thumb-sm">
                </c:otherwise>
              </c:choose>
            </td>
            <td style="padding: 12px 16px; font-weight: 600; color: #4b5563;">${v.videoId}</td>
            <td style="padding: 12px 16px; font-weight: 600; color: #111827; max-width: 250px;">
              <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" target="_blank" style="color: inherit; text-decoration: none;">
                ${v.title}
              </a>
            </td>
            <td style="padding: 12px 16px;">
              <span style="background: #eef2ff; color:#4f46e5; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: 600;">
                ${v.category != null ? v.category.categoryname : 'N/A'}
              </span>
            </td>
            <td style="padding: 12px 16px; color: #6b7280;">👁️ ${v.views}</td>
            <td style="padding: 12px 16px; color: #6b7280;">
              ${v.user != null && v.user.fullName != null && !v.user.fullName.isEmpty() ? v.user.fullName : (v.user != null ? v.user.userName : 'Admin')}
            </td>
            <td style="padding: 12px 16px;">
              <c:choose>
                <c:when test="${v.active}">
                  <span style="background: #dcfce7; color: #15803d; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: 600;">Hoạt động</span>
                </c:when>
                <c:otherwise>
                  <span style="background: #fee2e2; color: #b91c1c; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: 600;">Tạm khóa</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td style="padding: 12px 16px; text-align: center;">
              <div class="action-btns" style="justify-content: center;">
                <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="btn-sm btn-view" title="Xem & Play">▶ Play</a>
                <a href="${pageContext.request.contextPath}/admin/video/edit?id=${v.videoId}" class="btn-sm btn-edit">✏️ Sửa</a>
                <a href="${pageContext.request.contextPath}/admin/video/delete?id=${v.videoId}" class="btn-sm btn-del" onclick="return confirm('Bạn có chắc chắn muốn xóa video này không?')">🗑️ Xóa</a>
              </div>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>
