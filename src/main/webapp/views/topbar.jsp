<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="topbar">
  <a href="${pageContext.request.contextPath}/home" class="brand">🎬 VideoHub</a>
  <div style="display: flex; align-items: center; gap: 16px;">
    <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
    <a href="${pageContext.request.contextPath}/video">Video của tôi</a>

    <c:choose>
      <c:when test="${sessionScope.account != null}">
        <c:if test="${sessionScope.account.roleid == 1}">
          <a href="${pageContext.request.contextPath}/admin/videos">Quản lý Video</a>
          <a href="${pageContext.request.contextPath}/admin/categories">Quản lý Category</a>
        </c:if>
        <span style="color:#e0e7ff; font-size:.9rem; margin-left: 8px;">
          👤 Xin chào, <strong>${sessionScope.account.fullName != null && !sessionScope.account.fullName.isEmpty() ? sessionScope.account.fullName : sessionScope.account.userName}</strong>
        </span>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout" style="background:#ef4444; color:#fff; padding: 6px 14px; border-radius: 6px; text-decoration: none; font-weight: 500;">Đăng xuất</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/login" style="padding: 6px 14px; border-radius: 6px; text-decoration: none;">Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/register" style="background: #4f46e5; color: #fff; padding: 6px 14px; border-radius: 6px; text-decoration: none; font-weight: 500;">Đăng ký</a>
      </c:otherwise>
    </c:choose>
  </div>
</nav>
