<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Xác Thực Email Mới Bằng Mã OTP</title>
  <style>
    .otp-card {
      background: #fff;
      border-radius: 16px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.08);
      padding: 36px 32px;
      margin: 40px auto;
      max-width: 480px;
      text-align: center;
    }
    .otp-code-input {
      font-size: 28px;
      font-weight: bold;
      letter-spacing: 10px;
      text-align: center;
      padding: 10px;
      border-radius: 8px;
      border: 2px solid #6366f1;
    }
  </style>
</head>
<body>
<div class="container py-4">
  <div class="otp-card">
    <div style="font-size: 48px; margin-bottom: 12px;">📧</div>
    <h3 class="fw-bold text-primary mb-2">Xác Thực Email Mới</h3>
    <p class="text-muted small mb-3">
      Hệ thống đã gửi một mã xác thực OTP 6 số đến địa chỉ email mới:
      <br><b class="text-dark fs-6">${sessionScope.pendingNewEmail}</b>
    </p>

    <c:if test="${not empty alert}">
      <div class="alert alert-danger py-2 small" role="alert">
        <i class="bi bi-exclamation-circle-fill me-1"></i>${alert}
      </div>
    </c:if>

    <!-- Form nhập OTP đổi email mới (Yêu cầu 3) -->
    <form action="${pageContext.request.contextPath}/profile/verify-email" method="post" class="mt-4">
      <div class="mb-3 text-start">
        <label for="otp" class="form-label fw-semibold small">Nhập mã OTP 6 chữ số *</label>
        <input type="text" name="otp" id="otp" class="form-control otp-code-input" maxlength="6" pattern="[0-9]{6}" placeholder="------" required autofocus>
        <div class="form-text text-center mt-2 text-muted">
          (Mã OTP đồng thời hiển thị tại Server Console log để kiểm thử)
        </div>
      </div>

      <div class="d-grid gap-2 mt-4">
        <button type="submit" class="btn btn-primary py-2 fw-semibold">
          <i class="bi bi-shield-check me-1"></i>Xác Nhận & Cập Nhật Email
        </button>
        <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-secondary py-2">
          Quay lại hồ sơ
        </a>
      </div>
    </form>
  </div>
</div>
</body>
</html>
