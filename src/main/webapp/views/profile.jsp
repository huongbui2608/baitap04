<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Hồ Sơ Cá Nhân - User Profile</title>
  <style>
    .profile-card {
      background: #fff;
      border-radius: 16px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.06);
      padding: 32px;
      margin: 20px auto;
      max-width: 750px;
    }
    .profile-avatar-wrap {
      text-align: center;
      margin-bottom: 24px;
    }
    .profile-img-preview {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      object-fit: cover;
      border: 4px solid #4f46e5;
      box-shadow: 0 4px 12px rgba(79, 70, 229, 0.25);
    }
    .cloud-badge {
      background: #e0e7ff;
      color: #4338ca;
      font-size: 12px;
      padding: 4px 10px;
      border-radius: 20px;
      font-weight: 600;
      display: inline-block;
      margin-top: 8px;
    }
  </style>
</head>
<body>
<div class="container py-4">
  <div class="profile-card">
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
      <h3 class="fw-bold mb-0 text-primary"><i class="bi bi-person-bounding-box me-2"></i>Thông Tin Tài Khoản</h3>
      <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left me-1"></i>Về trang chủ
      </a>
    </div>

    <c:if test="${not empty message}">
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <c:if test="${not empty alert}">
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>${alert}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <!-- Form cập nhật Profile có validation và upload Cloudinary (Yêu cầu 2 & 3) -->
    <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" class="needs-validation" novalidate onsubmit="return validateProfileForm(event)">
      
      <!-- Ảnh đại diện Avatar -->
      <div class="profile-avatar-wrap">
        <c:choose>
          <c:when test="${not empty user.avatar && (user.avatar.startsWith('http://') || user.avatar.startsWith('https://'))}">
            <img src="${user.avatar}" alt="Avatar" class="profile-img-preview" id="avatarPreview">
          </c:when>
          <c:when test="${not empty user.avatar}">
            <img src="${pageContext.request.contextPath}/image?fname=${user.avatar}" alt="Avatar" class="profile-img-preview" id="avatarPreview">
          </c:when>
          <c:otherwise>
            <div class="profile-img-preview d-inline-flex align-items-center justify-content-center bg-primary text-white fs-1 fw-bold" id="avatarPreview">
              ${user.userName.substring(0,1).toUpperCase()}
            </div>
          </c:otherwise>
        </c:choose>
        <br>
        <span class="cloud-badge"><i class="bi bi-cloud-arrow-up-fill me-1"></i>Hỗ trợ tải lên Cloudinary</span>
        <div class="mt-3" style="max-width: 320px; margin: 0 auto;">
          <label class="form-label small text-muted">Thay đổi ảnh đại diện (Multipart):</label>
          <input type="file" name="avatarFile" id="avatarFileInput" accept="image/*" class="form-control form-control-sm" onchange="previewImage(event)">
        </div>
      </div>

      <div class="row g-3">
        <!-- Tên đăng nhập (Read-only) -->
        <div class="col-md-6">
          <label class="form-label fw-semibold">Tên đăng nhập (Username):</label>
          <input type="text" class="form-control bg-light" value="${user.userName}" readonly>
          <div class="form-text">Tên đăng nhập cố định không thể thay đổi.</div>
        </div>

        <!-- Vai trò (Role) -->
        <div class="col-md-6">
          <label class="form-label fw-semibold">Vai trò hệ thống:</label>
          <input type="text" class="form-control bg-light" value="${user.roleid == 1 ? 'Quản trị viên (Admin)' : (user.roleid == 2 ? 'Quản lý (Manager)' : 'Người dùng (User)')}" readonly>
        </div>

        <!-- Họ và tên (Editable with validation) -->
        <div class="col-md-12">
          <label for="fullname" class="form-label fw-semibold">Họ và tên *</label>
          <input type="text" name="fullname" id="fullname" class="form-control" value="${user.fullName}" required minlength="2" maxlength="100">
          <div class="invalid-feedback">Họ và tên bắt buộc nhập (tối thiểu 2 ký tự).</div>
        </div>

        <!-- Số điện thoại (Editable with validation) -->
        <div class="col-md-6">
          <label for="phone" class="form-label fw-semibold">Số điện thoại *</label>
          <input type="tel" name="phone" id="phone" class="form-control" value="${user.phone}" required pattern="^(0|\+84)[3|5|7|8|9][0-9]{8}$">
          <div class="invalid-feedback">Vui lòng nhập đúng số điện thoại di động Việt Nam (10 số).</div>
        </div>

        <!-- Email (Editable - gửi OTP xác thực nếu đổi email mới) -->
        <div class="col-md-6">
          <label for="email" class="form-label fw-semibold">Email tài khoản *</label>
          <input type="email" name="email" id="email" class="form-control" value="${user.email}" required>
          <div class="invalid-feedback">Vui lòng nhập định dạng email hợp lệ.</div>
        </div>

        <div class="col-12">
          <div class="alert alert-info py-2 small mb-0">
            <i class="bi bi-info-circle-fill me-1"></i>
            <b>Lưu ý:</b> Khi bạn thay đổi sang địa chỉ Email mới, hệ thống sẽ tự động gửi mã OTP xác nhận đến email mới đó để xác minh trước khi cập nhật hoàn tất.
          </div>
        </div>
      </div>

      <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary px-4">Hủy</a>
        <button type="submit" class="btn btn-primary px-4 fw-semibold">
          <i class="bi bi-save-fill me-1"></i>Lưu Thay Đổi
        </button>
      </div>
    </form>
  </div>
</div>

<script>
// Xem trước ảnh đại diện khi chọn file
function previewImage(event) {
  var file = event.target.files[0];
  if (file) {
    var reader = new FileReader();
    reader.onload = function(e) {
      var img = document.getElementById('avatarPreview');
      if (img.tagName === 'IMG') {
        img.src = e.target.result;
      } else {
        var newImg = document.createElement('img');
        newImg.src = e.target.result;
        newImg.className = 'profile-img-preview';
        newImg.id = 'avatarPreview';
        img.parentNode.replaceChild(newImg, img);
      }
    };
    reader.readAsDataURL(file);
  }
}

// Client-side Validation cho Form Profile (Yêu cầu 2)
function validateProfileForm(event) {
  var form = event.target;
  var fullname = document.getElementById('fullname').value.trim();
  var phone = document.getElementById('phone').value.trim();
  var email = document.getElementById('email').value.trim();

  var phoneRegex = /^(0|\+84)[3|5|7|8|9][0-9]{8}$/;
  var emailRegex = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/;

  if (fullname.length < 2) {
    alert('Họ và tên phải có ít nhất 2 ký tự!');
    event.preventDefault();
    return false;
  }

  if (!phoneRegex.test(phone)) {
    alert('Số điện thoại không đúng định dạng Việt Nam (10 chữ số)!');
    event.preventDefault();
    return false;
  }

  if (!emailRegex.test(email)) {
    alert('Email không đúng định dạng!');
    event.preventDefault();
    return false;
  }

  return true;
}
</script>
</body>
</html>
