<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Trang chủ - VideoHub</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    .hero-banner {
      background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
      color: #fff;
      padding: 36px 30px;
      border-radius: 16px;
      margin-bottom: 32px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 10px 25px rgba(79, 70, 229, 0.25);
    }
    .video-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 24px;
      margin-bottom: 40px;
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
  </style>
</head>
<body>
<jsp:include page="/views/topbar.jsp"/>

<div class="container" style="max-width: 1200px; margin: 24px auto; padding: 0 16px;">
  <div class="hero-banner">
    <div>
      <h1 style="font-size: 28px; margin-bottom: 8px;">🎉 Khám phá & Chia sẻ Video</h1>
      <p style="font-size: 15px; opacity: 0.9;">
        Xem các video mới nhất, học hỏi kiến thức Lập trình Web và quản lý bộ sưu tập video cá nhân.
      </p>
    </div>
    <div>
      <a href="${pageContext.request.contextPath}/video" style="background:#fff; color:#4f46e5; padding: 10px 20px; border-radius: 8px; font-weight: bold; text-decoration: none; display: inline-block;">
        📺 Video của tôi
      </a>
    </div>
  </div>

  <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
    <h2 style="font-size: 22px; color: #1f2937; display:flex; align-items:center; gap: 8px;">
      🔥 10 Video Mới Nhất
    </h2>
    <a href="${pageContext.request.contextPath}/video" class="link" style="font-size: 14px; font-weight: 600;">Xem tất cả video →</a>
  </div>

  <c:choose>
    <c:when test="${not empty top10Videos}">
      <div class="video-grid">
        <c:forEach var="v" items="${top10Videos}">
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
              <!-- Bấm vào tiêu đề để xem chi tiết và play video (Yêu cầu 4.4) -->
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
    </c:when>
    <c:otherwise>
      <div class="card" style="text-align:center; padding: 40px; color:#6b7280;">
        <p>Hiện chưa có video nào. Hãy đăng nhập với vai trò Quản trị viên để thêm video mới!</p>
      </div>
    </c:otherwise>
  </c:choose>
</div>
</body>
</html>
