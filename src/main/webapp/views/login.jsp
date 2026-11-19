<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đăng nhập - VideoHub</title>
</head>
<body>
<div class="container py-4">
  <div class="card shadow-sm mx-auto p-4" style="max-width: 440px; border-radius: 16px;">
    <div class="text-center mb-4">
      <div class="fs-1 text-primary">🔐</div>
      <h3 class="fw-bold mt-2">Đăng Nhập</h3>
      <p class="text-muted small">Nhập tài khoản của bạn để tiếp tục</p>
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
        <c:if test="${not empty pendingUsername}">
          <br><a href="${pageContext.request.contextPath}/verify-otp?username=${pendingUsername}" class="fw-bold text-decoration-underline text-danger">👉 Kích hoạt tài khoản bằng mã OTP ngay</a>
        </c:if>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <!-- FORM ĐĂNG NHẬP CÓ VALIDATION (Yêu cầu 2) -->
    <form action="${pageContext.request.contextPath}/login" method="post" class="needs-validation" novalidate onsubmit="return validateLoginForm(event)">
      <div class="mb-3">
        <label for="username" class="form-label fw-semibold small">Tên đăng nhập hoặc Email *</label>
        <div class="input-group">
          <span class="input-group-text"><i class="bi bi-person"></i></span>
          <input type="text" name="username" id="username" class="form-control" value="${username}" placeholder="Nhập username hoặc email" required minlength="3">
        </div>
        <div class="invalid-feedback small">Tên đăng nhập không được để trống (tối thiểu 3 ký tự).</div>
      </div>

      <div class="mb-3">
        <label for="password" class="form-label fw-semibold small">Mật khẩu *</label>
        <div class="input-group">
          <span class="input-group-text"><i class="bi bi-lock"></i></span>
          <input type="password" name="password" id="password" class="form-control" placeholder="Nhập mật khẩu" required minlength="3">
        </div>
        <div class="invalid-feedback small">Vui lòng nhập mật khẩu (tối thiểu 3 ký tự).</div>
      </div>

      <div class="d-flex justify-content-between align-items-center mb-3">
        <div class="form-check">
          <input type="checkbox" name="remember" id="remember" class="form-check-input">
          <label for="remember" class="form-check-label small text-muted">Nhớ đăng nhập (30 phút)</label>
        </div>
        <a href="${pageContext.request.contextPath}/forgot-password" class="small text-decoration-none">Quên mật khẩu?</a>
      </div>

      <div class="d-grid">
        <button type="submit" class="btn btn-primary py-2 fw-semibold">
          <i class="bi bi-box-arrow-in-right me-1"></i>Đăng Nhập
        </button>
      </div>
    </form>

    <div class="text-center mt-4 pt-3 border-top">
      <span class="small text-muted">Chưa có tài khoản? </span>
      <a href="${pageContext.request.contextPath}/register" class="small fw-bold text-decoration-none">Đăng ký ngay</a>
    </div>
  </div>
</div>

<script>
function validateLoginForm(event) {
  var form = event.target;
  var u = document.getElementById('username').value.trim();
  var p = document.getElementById('password').value;
  if (!u || u.length < 3) {
    document.getElementById('username').classList.add('is-invalid');
    event.preventDefault();
    return false;
  } else {
    document.getElementById('username').classList.remove('is-invalid');
  }
  if (!p || p.length < 3) {
    document.getElementById('password').classList.add('is-invalid');
    event.preventDefault();
    return false;
  } else {
    document.getElementById('password').classList.remove('is-invalid');
  }
  return true;
}
</script>
</body>
</html>
