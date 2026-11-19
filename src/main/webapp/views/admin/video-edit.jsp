<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Cập Nhật Video - Admin</title>
</head>
<body>
<div class="container py-3" style="max-width: 750px;">
  <div class="card shadow-sm border-0 rounded-3 p-4">
    <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
      <h4 class="fw-bold text-primary mb-0"><i class="bi bi-pencil-square me-2"></i>Chỉnh Sửa Video</h4>
      <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left me-1"></i>Danh sách
      </a>
    </div>

    <c:if test="${not empty alert}">
      <div class="alert alert-danger alert-dismissible fade show small" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-1"></i>${alert}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <!-- FORM EDIT VIDEO CÓ VALIDATION (Yêu cầu 2) -->
    <form action="${pageContext.request.contextPath}/admin/video/update" method="post" enctype="multipart/form-data" class="needs-validation" novalidate onsubmit="return validateVideoEditForm(event)">
      
      <div class="row g-3 mb-3">
        <div class="col-md-5">
          <label for="videoId" class="form-label fw-semibold small">Mã Video (Không được sửa)</label>
          <input type="text" id="videoId" name="videoId" value="${video.videoId}" class="form-control bg-light" readonly>
        </div>

        <div class="col-md-7">
          <label for="categoryId" class="form-label fw-semibold small">Danh mục (Category) *</label>
          <select id="categoryId" name="categoryId" class="form-select" required>
            <c:forEach var="c" items="${categories}">
              <option value="${c.categoryid}" ${video.category != null && video.category.categoryid == c.categoryid ? 'selected' : ''}>
                ${c.categoryname}
              </option>
            </c:forEach>
          </select>
        </div>
      </div>

      <div class="mb-3">
        <label for="title" class="form-label fw-semibold small">Tiêu đề Video *</label>
        <input type="text" id="title" name="title" value="${video.title}" class="form-control" required minlength="3">
        <div class="invalid-feedback small">Tiêu đề video bắt buộc (tối thiểu 3 ký tự).</div>
      </div>

      <!-- Poster Thumbnail (Multipart Upload hoặc URL) -->
      <div class="card bg-light border-dashed p-3 mb-3">
        <label class="form-label fw-semibold small mb-2"><i class="bi bi-image me-1"></i>Ảnh Poster Thumbnail</label>
        <div class="d-flex align-items-center gap-3 mb-2">
          <c:choose>
            <c:when test="${video.poster != null && (video.poster.startsWith('http://') || video.poster.startsWith('https://'))}">
              <img src="${video.poster}" alt="Poster" class="rounded shadow-sm" style="width: 100px; height: 60px; object-fit: cover;">
            </c:when>
            <c:when test="${video.poster != null && !video.poster.isEmpty()}">
              <img src="${pageContext.request.contextPath}/image?fname=${video.poster}" alt="Poster" class="rounded shadow-sm" style="width: 100px; height: 60px; object-fit: cover;">
            </c:when>
          </c:choose>
          <span class="small text-muted">Poster hiện tại. Chọn file mới hoặc dán link mới nếu muốn thay đổi.</span>
        </div>
        <div class="row g-2">
          <div class="col-md-6">
            <span class="small text-muted d-block mb-1">Chọn file ảnh mới:</span>
            <input type="file" name="posterFile" accept="image/*" class="form-control form-control-sm">
          </div>
          <div class="col-md-6">
            <span class="small text-muted d-block mb-1">Hoặc dán liên kết ảnh mới:</span>
            <input type="text" name="posterUrl" value="${video.poster}" class="form-control form-control-sm">
          </div>
        </div>
      </div>

      <!-- Video File / URL -->
      <div class="card bg-light border-dashed p-3 mb-3">
        <label class="form-label fw-semibold small mb-2"><i class="bi bi-play-btn me-1"></i>Nguồn Phát Video</label>
        <div class="row g-2">
          <div class="col-md-6">
            <span class="small text-muted d-block mb-1">Chọn file video mới (MP4/WebM):</span>
            <input type="file" name="videoFile" accept="video/*" class="form-control form-control-sm">
          </div>
          <div class="col-md-6">
            <span class="small text-muted d-block mb-1">Hoặc dán URL video mới:</span>
            <input type="text" name="videoUrl" value="${video.videoUrl}" class="form-control form-control-sm">
          </div>
        </div>
      </div>

      <div class="mb-3">
        <label for="description" class="form-label fw-semibold small">Mô tả chi tiết Video:</label>
        <textarea id="description" name="description" rows="3" class="form-control">${video.description}</textarea>
      </div>

      <div class="form-check mb-4">
        <input class="form-check-input" type="checkbox" name="active" id="active" value="1" ${video.active ? 'checked' : ''}>
        <label class="form-check-label small fw-medium" for="active">
          Công khai video này cho mọi người xem (Active)
        </label>
      </div>

      <div class="d-flex justify-content-end gap-2 pt-2 border-top">
        <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-secondary px-3">Hủy</a>
        <button type="submit" class="btn btn-primary px-4 fw-semibold">
          <i class="bi bi-check2-circle me-1"></i>Lưu Thay Đổi
        </button>
      </div>
    </form>
  </div>
</div>

<script>
function validateVideoEditForm(event) {
  var t = document.getElementById('title').value.trim();
  if (!t || t.length < 3) {
    document.getElementById('title').classList.add('is-invalid');
    event.preventDefault();
    return false;
  }
  document.getElementById('title').classList.remove('is-invalid');
  return true;
}
</script>
</body>
</html>
