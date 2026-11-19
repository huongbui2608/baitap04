<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quên Mật Khẩu - VideoHub</title>
</head>
<body>
<div class="container py-4">
  <div class="card shadow-sm mx-auto p-4" style="max-width: 460px; border-radius: 16px;">
    <div class="text-center mb-4">
      <div class="fs-1 text-warning">🔑</div>
      <h3 class="fw-bold mt-2">Quên Mật Khẩu</h3>
      <p class="text-muted small">
        Nhập Email hoặc Tên đăng nhập của bạn. Hệ thống sẽ tự động gửi mã OTP xác nhận để đặt lại mật khẩu mới.
      </p>
    </div>

    <c:if test="${not empty alert}">
      <div class="alert alert-danger alert-dismissible fade show small" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-1"></i>${alert}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <!-- FORM QUÊN MẬT KHẨU CÓ VALIDATION (Yêu cầu 2) -->
    <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="needs-validation" novalidate onsubmit="return validateForgotForm(event)">
      <div class="mb-3">
        <label for="emailOrUsername" class="form-label fw-semibold small">Email hoặc Tên đăng nhập *</label>
        <div class="input-group">
          <span class="input-group-text"><i class="bi bi-envelope"></i></span>
          <input type="text" name="emailOrUsername" id="emailOrUsername" class="form-control" value="${emailOrUsername}" placeholder="email@example.com hoặc username" required minlength="3" autofocus>
        </div>
        <div class="invalid-feedback small">Vui lòng nhập Email hoặc Tên đăng nhập (tối thiểu 3 ký tự).</div>
      </div>

      <div class="d-grid mt-4">
        <button type="submit" class="btn btn-primary py-2 fw-semibold">
          <i class="bi bi-send-fill me-1"></i>Gửi Mã Xác Nhận OTP
        </button>
      </div>
    </form>

    <div class="text-center mt-4 pt-3 border-top">
      <span class="small text-muted">Nhớ lại mật khẩu? </span>
      <a href="${pageContext.request.contextPath}/login" class="small fw-bold text-decoration-none">Đăng nhập</a>
    </div>
  </div>
</div>

<script>
function validateForgotForm(event) {
  var input = document.getElementById('emailOrUsername').value.trim();
  if (!input || input.length < 3) {
    document.getElementById('emailOrUsername').classList.add('is-invalid');
    event.preventDefault();
    return false;
  }
  document.getElementById('emailOrUsername').classList.remove('is-invalid');
  return true;
}
</script>
</body>
</html>
