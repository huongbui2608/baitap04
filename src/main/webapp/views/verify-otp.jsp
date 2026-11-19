<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Kích Hoạt Tài Khoản - VideoHub</title>
  <style>
    .otp-input-field {
      font-size: 26px;
      font-weight: bold;
      letter-spacing: 10px;
      text-align: center;
      border: 2px solid #6366f1;
    }
  </style>
</head>
<body>
<div class="container py-4">
  <div class="card shadow-sm mx-auto p-4" style="max-width: 480px; border-radius: 16px;">
    <div class="text-center mb-3">
      <div class="fs-1 text-primary">📩</div>
      <h3 class="fw-bold mt-2">Kích Hoạt Tài Khoản</h3>
      <p class="text-muted small">
        Vui lòng kiểm tra email của bạn và nhập mã xác thực OTP 6 số để kích hoạt tài khoản.
      </p>
    </div>

    <c:if test="${not empty message}">
      <div class="alert alert-success alert-dismissible fade show small" role="alert">
        <i class="bi bi-check-circle-fill me-1"></i>${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <c:if test="${not empty alert}">
      <div class="alert alert-danger alert-dismissible fade show small" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-1"></i>${alert}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <!-- FORM XÁC THỰC OTP KÍCH HOẠT TÀI KHOẢN (Yêu cầu 2) -->
    <form action="${pageContext.request.contextPath}/verify-otp" method="post" class="needs-validation" novalidate>
      <div class="mb-3">
        <label for="username" class="form-label fw-semibold small">Tên đăng nhập hoặc Email *</label>
        <div class="input-group">
          <span class="input-group-text"><i class="bi bi-person"></i></span>
          <input type="text" name="username" id="username" class="form-control" value="${username}" placeholder="Nhập tên đăng nhập" required minlength="3">
        </div>
      </div>

      <div class="mb-3">
        <label for="otp" class="form-label fw-semibold small">Mã xác thực OTP (6 chữ số) *</label>
        <input type="text" name="otp" id="otp" class="form-control otp-input-field" maxlength="6" pattern="[0-9]{6}" placeholder="------" required autofocus>
        <div class="form-text text-muted text-center small mt-1">
          (Mã OTP đồng thời hiển thị tại Server Console log để kiểm thử)
        </div>
      </div>

      <div class="d-grid mt-4">
        <button type="submit" class="btn btn-primary py-2 fw-semibold">
          <i class="bi bi-patch-check-fill me-1"></i>Kích Hoạt Tài Khoản Ngay
        </button>
      </div>
    </form>

    <div class="text-center mt-3 pt-3 border-top">
      <span class="small text-muted">Chưa nhận được mã? </span>
      <a href="${pageContext.request.contextPath}/verify-otp?action=resend&username=${username}" class="small fw-bold text-decoration-none">
        Gửi lại mã OTP
      </a>
      <div class="mt-2">
        <a href="${pageContext.request.contextPath}/login" class="small text-muted text-decoration-none">← Quay lại Đăng nhập</a>
      </div>
    </div>
  </div>
</div>
</body>
</html>
