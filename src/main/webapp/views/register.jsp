<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đăng ký tài khoản - VideoHub</title>
</head>
<body>
<div class="container py-4">
  <div class="card shadow-sm mx-auto p-4" style="max-width: 520px; border-radius: 16px;">
    <div class="text-center mb-3">
      <div class="fs-1 text-primary">📝</div>
      <h3 class="fw-bold mt-2">Đăng Ký Tài Khoản</h3>
      <p class="text-muted small">Mã OTP kích hoạt sẽ được gửi tự động qua email của bạn</p>
    </div>

    <c:if test="${not empty alert}">
      <div class="alert alert-danger alert-dismissible fade show small" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-1"></i>${alert}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <!-- FORM ĐĂNG KÝ CÓ VALIDATION (Yêu cầu 2) -->
    <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" novalidate onsubmit="return validateRegisterForm(event)">
      
      <div class="mb-3">
        <label for="username" class="form-label fw-semibold small">Tên đăng nhập *</label>
        <input type="text" name="username" id="username" class="form-control" value="${username}" required pattern="^[a-zA-Z0-9_]{3,30}$" placeholder="Từ 3-30 ký tự, không dấu">
        <div class="invalid-feedback small">Tên đăng nhập 3-30 ký tự, chỉ chứa chữ cái, số và gạch dưới.</div>
      </div>

      <div class="mb-3">
        <label for="fullname" class="form-label fw-semibold small">Họ và tên đầy đủ *</label>
        <input type="text" name="fullname" id="fullname" class="form-control" value="${fullname}" required minlength="2" placeholder="VD: Nguyễn Văn A">
        <div class="invalid-feedback small">Họ và tên tối thiểu 2 ký tự.</div>
      </div>

      <div class="row g-2 mb-3">
        <div class="col-md-6">
          <label for="email" class="form-label fw-semibold small">Email (nhận mã OTP) *</label>
          <input type="email" name="email" id="email" class="form-control" value="${email}" required placeholder="email@example.com">
          <div class="invalid-feedback small">Vui lòng nhập đúng định dạng email.</div>
        </div>
        <div class="col-md-6">
          <label for="phone" class="form-label fw-semibold small">Số điện thoại *</label>
          <input type="tel" name="phone" id="phone" class="form-control" value="${phone}" required pattern="^(0|\+84)[3|5|7|8|9][0-9]{8}$" placeholder="0901234567">
          <div class="invalid-feedback small">10 số di động Việt Nam.</div>
        </div>
      </div>

      <div class="row g-2 mb-3">
        <div class="col-md-6">
          <label for="password" class="form-label fw-semibold small">Mật khẩu (BCrypt) *</label>
          <input type="password" name="password" id="password" class="form-control" required minlength="6" placeholder="Tối thiểu 6 ký tự">
          <div class="invalid-feedback small">Mật khẩu từ 6 ký tự trở lên.</div>
        </div>
        <div class="col-md-6">
          <label for="repassword" class="form-label fw-semibold small">Nhập lại mật khẩu *</label>
          <input type="password" name="repassword" id="repassword" class="form-control" required minlength="6" placeholder="Xác nhận mật khẩu">
          <div id="repassFeedback" class="small mt-1"></div>
        </div>
      </div>

      <div class="d-grid mt-4">
        <button type="submit" class="btn btn-primary py-2 fw-semibold">
          <i class="bi bi-person-check-fill me-1"></i>Đăng Ký & Nhận Mã OTP
        </button>
      </div>
    </form>

    <div class="text-center mt-3 pt-3 border-top">
      <span class="small text-muted">Đã có tài khoản? </span>
      <a href="${pageContext.request.contextPath}/login" class="small fw-bold text-decoration-none">Đăng nhập</a>
    </div>
  </div>
</div>

<script>
// Real-time check khớp mật khẩu
document.getElementById('repassword').addEventListener('input', function() {
  var p = document.getElementById('password').value;
  var rp = this.value;
  var fb = document.getElementById('repassFeedback');
  if (rp.length > 0) {
    if (p === rp) {
      fb.innerHTML = '<span class="text-success"><i class="bi bi-check-circle me-1"></i>Mật khẩu khớp</span>';
      this.classList.remove('is-invalid');
      this.classList.add('is-valid');
    } else {
      fb.innerHTML = '<span class="text-danger"><i class="bi bi-x-circle me-1"></i>Mật khẩu không khớp</span>';
      this.classList.add('is-invalid');
      this.classList.remove('is-valid');
    }
  } else {
    fb.innerHTML = '';
  }
});

function validateRegisterForm(event) {
  var p = document.getElementById('password').value;
  var rp = document.getElementById('repassword').value;
  if (p !== rp) {
    alert('Mật khẩu nhập lại không khớp!');
    event.preventDefault();
    return false;
  }
  return true;
}
</script>
</body>
</html>
