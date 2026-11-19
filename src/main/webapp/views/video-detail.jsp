<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${video.title} - VideoHub</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    .detail-container {
      max-width: 1200px;
      margin: 24px auto;
      padding: 0 16px;
      display: grid;
      grid-template-columns: 1fr 340px;
      gap: 32px;
    }
    @media (max-width: 900px) {
      .detail-container {
        grid-template-columns: 1fr;
      }
    }
    .player-box {
      width: 100%;
      background: #000;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 10px 30px rgba(0,0,0,0.25);
    }
    .player-box video {
      width: 100%;
      max-height: 540px;
      display: block;
    }
    .player-box iframe {
      width: 100%;
      height: 480px;
      border: none;
      display: block;
    }
    .video-info-box {
      background: #fff;
      border-radius: 12px;
      padding: 24px;
      margin-top: 20px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    }
    .video-main-title {
      font-size: 24px;
      font-weight: 700;
      color: #111827;
      margin-bottom: 12px;
      line-height: 1.3;
    }
    .video-stats {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid #e5e7eb;
      padding-bottom: 16px;
      margin-bottom: 16px;
      font-size: 14px;
      color: #6b7280;
    }
    .uploader-info {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 16px;
    }
    .uploader-avatar {
      width: 44px;
      height: 44px;
      border-radius: 50%;
      background: #4f46e5;
      color: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
      font-size: 18px;
    }
    .video-desc {
      background: #f9fafb;
      padding: 16px;
      border-radius: 8px;
      color: #374151;
      line-height: 1.6;
      font-size: 14px;
      white-space: pre-line;
    }
    .sidebar-card {
      background: #fff;
      border-radius: 12px;
      padding: 20px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    }
    .rel-item {
      display: flex;
      gap: 12px;
      margin-bottom: 16px;
      text-decoration: none;
      color: inherit;
      padding-bottom: 12px;
      border-bottom: 1px solid #f3f4f6;
    }
    .rel-item:last-child {
      border-bottom: none;
      margin-bottom: 0;
      padding-bottom: 0;
    }
    .rel-item:hover .rel-title {
      color: #4f46e5;
    }
    .rel-thumb {
      width: 100px;
      height: 64px;
      border-radius: 6px;
      overflow: hidden;
      flex-shrink: 0;
      background: #111827;
    }
    .rel-thumb img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .rel-info {
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }
    .rel-title {
      font-size: 13px;
      font-weight: 600;
      line-height: 1.3;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
    .rel-meta {
      font-size: 11px;
      color: #9ca3af;
    }
  </style>
</head>
<body>
<jsp:include page="/views/topbar.jsp"/>

<div class="detail-container">
  <!-- Cột bên trái: Player và thông tin video (Yêu cầu 4.4) -->
  <div>
    <div class="player-box">
      <c:choose>
        <%-- Nếu là link YouTube --%>
        <c:when test="${video.videoUrl != null && (video.videoUrl.contains('youtube.com') || video.videoUrl.contains('youtu.be'))}">
          <c:set var="ytId" value="${video.videoUrl}" />
          <%-- Lấy ID youtube --%>
          <iframe src="${video.videoUrl}" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        </c:when>

        <%-- Nếu là file video upload hoặc link MP4 --%>
        <c:otherwise>
          <c:set var="vsrc" value="${video.videoUrl}" />
          <c:if test="${video.videoUrl != null && !video.videoUrl.startsWith('http://') && !video.videoUrl.startsWith('https://')}">
            <c:set var="vsrc" value="${pageContext.request.contextPath}/file?fname=${video.videoUrl}" />
          </c:if>
          <c:set var="psrc" value="${video.poster}" />
          <c:if test="${video.poster != null && !video.poster.startsWith('http://') && !video.poster.startsWith('https://')}">
            <c:set var="psrc" value="${pageContext.request.contextPath}/image?fname=${video.poster}" />
          </c:if>

          <video controls autoplay poster="${psrc}">
            <source src="${vsrc}" type="video/mp4">
            Trình duyệt của bạn không hỗ trợ phát thẻ video HTML5.
          </video>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="video-info-box">
      <h1 class="video-main-title">${video.title}</h1>
      <div class="video-stats">
        <div>
          <span>👁️ <b>${video.views}</b> lượt xem</span>
          <c:if test="${video.category != null}">
            <span style="margin-left: 12px; background: #eef2ff; color:#4f46e5; padding: 2px 8px; border-radius: 4px; font-weight: 600; font-size: 12px;">
              ${video.category.categoryname}
            </span>
          </c:if>
        </div>
        <div>
          <a href="${pageContext.request.contextPath}/video" class="link">← Quay lại danh sách video</a>
        </div>
      </div>

      <div class="uploader-info">
        <div class="uploader-avatar">
          ${video.user != null && video.user.fullName != null && !video.user.fullName.isEmpty() ? video.user.fullName.substring(0,1).toUpperCase() : 'U'}
        </div>
        <div>
          <div style="font-weight: 600; color: #111827;">
            ${video.user != null && video.user.fullName != null && !video.user.fullName.isEmpty() ? video.user.fullName : (video.user != null ? video.user.userName : 'Admin')}
          </div>
          <div style="font-size: 12px; color: #6b7280;">Người đăng tải video</div>
        </div>
      </div>

      <div class="video-desc">
        <b>Mô tả video:</b><br>
        ${video.description != null && !video.description.isEmpty() ? video.description : 'Không có mô tả chi tiết cho video này.'}
      </div>
    </div>
  </div>

  <!-- Cột bên phải: Danh sách video gợi ý -->
  <div>
    <div class="sidebar-card">
      <h3 style="font-size: 16px; font-weight: 700; color: #111827; margin-bottom: 16px;">
        💡 Video khác dành cho bạn
      </h3>
      <c:forEach var="rel" items="${relatedVideos}">
        <c:if test="${rel.videoId != video.videoId}">
          <a href="${pageContext.request.contextPath}/video/detail?id=${rel.videoId}" class="rel-item">
            <div class="rel-thumb">
              <c:choose>
                <c:when test="${rel.poster != null && (rel.poster.startsWith('http://') || rel.poster.startsWith('https://'))}">
                  <img src="${rel.poster}" alt="${rel.title}">
                </c:when>
                <c:when test="${rel.poster != null && !rel.poster.isEmpty()}">
                  <img src="${pageContext.request.contextPath}/image?fname=${rel.poster}" alt="${rel.title}">
                </c:when>
                <c:otherwise>
                  <img src="https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600" alt="${rel.title}">
                </c:otherwise>
              </c:choose>
            </div>
            <div class="rel-info">
              <div class="rel-title">${rel.title}</div>
              <div class="rel-meta">👁️ ${rel.views} lượt xem</div>
            </div>
          </a>
        </c:if>
      </c:forEach>
    </div>
  </div>
</div>
</body>
</html>
