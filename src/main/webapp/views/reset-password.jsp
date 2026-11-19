<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đặt Lại Mật Khẩu Mới - VideoHub</title>
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
      <div class="fs-1 text-success">🛡️</div>
      <h3 class="fw-bold mt-2">Đặt Lại Mật Khẩu</h3>
      <p class="text-muted small">Nhập mã OTP 6 số đã được gửi qua email và thiết lập mật khẩu mới</p>
    </div>

    <c:if test="${not empty alert}">
      <div class="alert alert-danger alert-dismissible fade show small" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-1"></i>${alert}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <!-- FORM RESET PASSWORD CÓ VALIDATION (Yêu cầu 2) -->
    <form action="${pageContext.request.contextPath}/reset-password" method="post" class="needs-validation" novalidate onsubmit="return validateResetForm(event)">
      <div class="mb-3">
        <label for="emailOrUsername" class="form-label fw-semibold small">Tên đăng nhập hoặc Email *</label>
        <div class="input-group">
          <span class="input-group-text"><i class="bi bi-person"></i></span>
          <input type="text" name="emailOrUsername" id="emailOrUsername" class="form-control" value="${resetUser}" placeholder="Nhập email hoặc username" required minlength="3">
        </div>
        <div class="invalid-feedback small">Vui lòng nhập tên đăng nhập hoặc email.</div>
      </div>

      <div class="mb-3">
        <label for="otp" class="form-label fw-semibold small">Mã xác thực OTP (6 chữ số) *</label>
        <input type="text" name="otp" id="otp" class="form-control otp-input-field" maxlength="6" pattern="[0-9]{6}" placeholder="------" required autofocus>
        <div class="form-text text-muted text-center small mt-1">Kiểm tra hộp thư email hoặc Server Console log</div>
      </div>

      <div class="row g-2 mb-3">
        <div class="col-md-6">
          <label for="newPassword" class="form-label fw-semibold small">Mật khẩu mới *</label>
          <input type="password" name="newPassword" id="newPassword" class="form-control" required minlength="6" placeholder="Tối thiểu 6 ký tự">
          <div class="invalid-feedback small">Mật khẩu từ 6 ký tự.</div>
        </div>
        <div class="col-md-6">
          <label for="rePassword" class="form-label fw-semibold small">Xác nhận mật khẩu *</label>
          <input type="password" name="rePassword" id="rePassword" class="form-control" required minlength="6" placeholder="Nhập lại mật khẩu">
          <div id="resetMatchMsg" class="small mt-1"></div>
        </div>
      </div>

      <div class="d-grid mt-4">
        <button type="submit" class="btn btn-primary py-2 fw-semibold">
          <i class="bi bi-check-circle-fill me-1"></i>Cập Nhật Mật Khẩu Mới
        </button>
      </div>
    </form>

    <div class="text-center mt-3 pt-3 border-top">
      <span class="small text-muted">Quay lại </span>
      <a href="${pageContext.request.contextPath}/login" class="small fw-bold text-decoration-none">Đăng nhập</a>
    </div>
  </div>
</div>

<script>
document.getElementById('rePassword').addEventListener('input', function() {
  var p1 = document.getElementById('newPassword').value;
  var p2 = this.value;
  var msg = document.getElementById('resetMatchMsg');
  if (p2.length > 0) {
    if (p1 === p2) {
      msg.innerHTML = '<span class="text-success"><i class="bi bi-check-circle me-1"></i>Mật khẩu khớp</span>';
      this.classList.remove('is-invalid');
      this.classList.add('is-valid');
    } else {
      msg.innerHTML = '<span class="text-danger"><i class="bi bi-x-circle me-1"></i>Không khớp</span>';
      this.classList.add('is-invalid');
      this.classList.remove('is-valid');
    }
  } else {
    msg.innerHTML = '';
  }
});

function validateResetForm(event) {
  var p1 = document.getElementById('newPassword').value;
  var p2 = document.getElementById('rePassword').value;
  var otp = document.getElementById('otp').value.trim();

  if (!/^[0-9]{6}$/.test(otp)) {
    alert('Mã OTP phải gồm đúng 6 chữ số!');
    event.preventDefault();
    return false;
  }
  if (p1 !== p2) {
    alert('Mật khẩu xác nhận không khớp!');
    event.preventDefault();
    return false;
  }
  return true;
}
</script>
</body>
</html>
