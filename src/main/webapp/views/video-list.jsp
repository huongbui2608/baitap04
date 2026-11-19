<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Danh sách Video - VideoHub</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    .video-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 24px;
      margin-bottom: 32px;
    }
    .video-card {
      background: #fff;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 4px 15px rgba(0,0,0,0.06);
      transition: transform .2s, box-shadow .2s;
      display: flex;
      flex-direction: column;
    }
    .video-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 24px rgba(0,0,0,0.12);
    }
    .poster-wrap {
      position: relative;
      width: 100%;
      height: 170px;
      background: #111827;
      overflow: hidden;
    }
    .poster-wrap img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform .3s;
    }
    .video-card:hover .poster-wrap img {
      transform: scale(1.05);
    }
    .play-badge {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background: rgba(0,0,0,0.65);
      color: #fff;
      width: 48px;
      height: 48px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 20px;
      opacity: 0.9;
      transition: background .2s, transform .2s;
    }
    .video-card:hover .play-badge {
      background: #4f46e5;
      transform: translate(-50%, -50%) scale(1.1);
    }
    .video-info {
      padding: 16px;
      display: flex;
      flex-direction: column;
      flex-grow: 1;
    }
    .video-title {
      font-size: 16px;
      font-weight: 700;
      color: #111827;
      text-decoration: none;
      line-height: 1.4;
      margin-bottom: 8px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
    .video-title:hover {
      color: #4f46e5;
      text-decoration: underline;
    }
    .video-meta {
      font-size: 13px;
      color: #6b7280;
      margin-top: auto;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .badge-cat {
      display: inline-block;
      background: #eef2ff;
      color: #4f46e5;
      padding: 3px 8px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 600;
      margin-bottom: 8px;
    }
    .pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 8px;
      margin: 32px 0 48px;
    }
    .page-item {
      display: inline-block;
      padding: 8px 16px;
      border-radius: 8px;
      background: #fff;
      border: 1px solid #e5e7eb;
      color: #374151;
      text-decoration: none;
      font-weight: 600;
      transition: all .2s;
    }
    .page-item:hover {
      background: #f3f4f6;
      border-color: #d1d5db;
    }
    .page-item.active {
      background: #4f46e5;
      color: #fff;
      border-color: #4f46e5;
    }
    .page-item.disabled {
      opacity: 0.5;
      pointer-events: none;
    }
  </style>
</head>
<body>
<jsp:include page="/views/topbar.jsp"/>

<div class="container" style="max-width: 1200px; margin: 24px auto; padding: 0 16px;">
  <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px; border-bottom: 1px solid #e5e7eb; padding-bottom: 16px;">
    <div>
      <h1 style="font-size: 24px; color: #111827; margin-bottom: 4px;">
        <c:choose>
          <c:when test="${isUserVideos}">
            👤 Video của tôi (${currentUser.fullName != null && !currentUser.fullName.isEmpty() ? currentUser.fullName : currentUser.userName})
          </c:when>
          <c:otherwise>
            🎬 Tất cả Video trong hệ thống
          </c:otherwise>
        </c:choose>
      </h1>
      <p style="color: #6b7280; font-size: 14px;">
        Phân trang hiển thị 6 video mỗi trang (Tổng số: <b>${totalVideos}</b> video)
      </p>
    </div>

    <c:if test="${sessionScope.account != null && sessionScope.account.roleid == 1}">
      <a href="${pageContext.request.contextPath}/admin/video/add" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
        ➕ Thêm video mới
      </a>
    </c:if>
  </div>

  <c:choose>
    <c:when test="${not empty videoList}">
      <div class="video-grid">
        <c:forEach var="v" items="${videoList}">
          <div class="video-card">
            <div class="poster-wrap">
              <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}">
                <c:choose>
                  <c:when test="${v.poster != null && (v.poster.startsWith('http://') || v.poster.startsWith('https://'))}">
                    <img src="${v.poster}" alt="${v.title}">
                  </c:when>
                  <c:when test="${v.poster != null && !v.poster.isEmpty()}">
                    <img src="${pageContext.request.contextPath}/image?fname=${v.poster}" alt="${v.title}">
                  </c:when>
                  <c:otherwise>
                    <img src="https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600" alt="${v.title}">
                  </c:otherwise>
                </c:choose>
                <div class="play-badge">▶</div>
              </a>
            </div>
            <div class="video-info">
              <c:if test="${v.category != null}">
                <div><span class="badge-cat">${v.category.categoryname}</span></div>
              </c:if>
              <!-- Bấm chuột vào tiêu đề của video để hiển thị chi tiết và play (Yêu cầu 4.4) -->
              <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="video-title" title="${v.title}">
                ${v.title}
              </a>
              <div class="video-meta">
                <span>👁️ ${v.views} lượt xem</span>
                <c:if test="${v.user != null}">
                  <span>👤 ${v.user.fullName != null && !v.user.fullName.isEmpty() ? v.user.fullName : v.user.userName}</span>
                </c:if>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>

      <!-- Phân trang 6 sp/trang (Yêu cầu 4.3) -->
      <c:if test="${totalPages > 1}">
        <div class="pagination">
          <a href="${pageContext.request.contextPath}/video?page=${currentPage - 1}" class="page-item ${currentPage == 1 ? 'disabled' : ''}">
            « Trước
          </a>

          <c:forEach var="p" begin="1" end="${totalPages}">
            <a href="${pageContext.request.contextPath}/video?page=${p}" class="page-item ${currentPage == p ? 'active' : ''}">
              ${p}
            </a>
          </c:forEach>

          <a href="${pageContext.request.contextPath}/video?page=${currentPage + 1}" class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
            Sau »
          </a>
        </div>
      </c:if>
    </c:when>
    <c:otherwise>
      <div class="card" style="text-align:center; padding: 48px; color: #6b7280; max-width: 600px; margin: 40px auto;">
        <div style="font-size: 48px; margin-bottom: 12px;">📭</div>
        <h3>Chưa có video nào</h3>
        <p style="margin-top: 8px;">Hiện tại chưa có video nào được đăng tải bởi tài khoản này.</p>
        <div style="margin-top: 20px;">
          <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Về trang chủ</a>
        </div>
      </div>
    </c:otherwise>
  </c:choose>
</div>
</body>
</html>
