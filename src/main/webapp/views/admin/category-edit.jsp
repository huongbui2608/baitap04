<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Cập Nhật Category - Admin</title>
</head>
<body>
<div class="container py-3" style="max-width: 650px;">
  <div class="card shadow-sm border-0 rounded-3 p-4">
    <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
      <h4 class="fw-bold text-primary mb-0"><i class="bi bi-pencil-square me-2"></i>Chỉnh Sửa Danh Mục</h4>
      <a href="<c:url value="/admin/categories"/>" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left me-1"></i>Danh sách
      </a>
    </div>

    <c:if test="${not empty alert}">
      <div class="alert alert-danger alert-dismissible fade show small" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-1"></i>${alert}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <!-- FORM EDIT CATEGORY CÓ VALIDATION (Yêu cầu 2) -->
    <form action="<c:url value="/admin/category/update"/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate onsubmit="return validateCategoryEditForm(event)">
      <input type="hidden" name="categoryid" value="${cate.categoryId}">

      <div class="mb-3">
        <label for="categoryname" class="form-label fw-semibold small">Tên Danh Mục (Category Name) *</label>
        <input type="text" id="categoryname" name="categoryname" value="${cate.categoryname}" class="form-control" required minlength="2">
        <div class="invalid-feedback small">Tên danh mục không được để trống (tối thiểu 2 ký tự).</div>
      </div>

      <div class="mb-3">
        <label for="images" class="form-label fw-semibold small">Đường dẫn ảnh Online (URL):</label>
        <div class="input-group">
          <span class="input-group-text"><i class="bi bi-link-45deg"></i></span>
          <input type="text" id="images" name="images" value="${cate.images}" class="form-control">
        </div>
      </div>

      <div class="mb-3">
        <label class="form-label fw-semibold small">Hình ảnh hiện tại:</label>
        <div class="p-2 border rounded bg-light mb-2 d-flex align-items-center gap-3">
          <c:choose>
            <c:when test="${not empty cate.images && (cate.images.startsWith('http://') || cate.images.startsWith('https://'))}">
              <img height="80" width="120" src="${cate.images}" class="rounded object-fit-cover shadow-sm" alt="Category Image" />
            </c:when>
            <c:when test="${not empty cate.images}">
              <img height="80" width="120" src="<c:url value="/image?fname=${cate.images}" />" class="rounded object-fit-cover shadow-sm" alt="Category Image" />
            </c:when>
            <c:otherwise>
              <div class="text-muted small">Chưa có ảnh danh mục</div>
            </c:otherwise>
          </c:choose>
          <span class="text-muted small">Chọn file mới bên dưới để thay thế ảnh cũ (nếu muốn):</span>
        </div>
        <input type="file" id="images1" name="images1" accept="image/*" class="form-control">
      </div>

      <div class="mb-3">
        <label class="form-label fw-semibold small">Trạng thái (Status):</label>
        <div class="d-flex gap-3 mt-1">
          <div class="form-check">
            <input class="form-check-input" type="radio" id="ston" name="status" value="1" ${cate.status == 1 ? 'checked' : ''}>
            <label class="form-check-label text-success fw-medium" for="ston">
              <i class="bi bi-check-circle me-1"></i>Hoạt động
            </label>
          </div>
          <div class="form-check">
            <input class="form-check-input" type="radio" id="stoff" name="status" value="0" ${cate.status != 1 ? 'checked' : ''}>
            <label class="form-check-label text-secondary fw-medium" for="stoff">
              <i class="bi bi-lock me-1"></i>Khóa
            </label>
          </div>
        </div>
      </div>

      <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
        <a href="<c:url value="/admin/categories"/>" class="btn btn-secondary px-3">Hủy</a>
        <button type="submit" class="btn btn-primary px-4 fw-semibold">
          <i class="bi bi-check2-circle me-1"></i>Lưu Thay Đổi
        </button>
      </div>
    </form>
  </div>
</div>

<script>
function validateCategoryEditForm(event) {
  var name = document.getElementById('categoryname').value.trim();
  if (!name || name.length < 2) {
    document.getElementById('categoryname').classList.add('is-invalid');
    event.preventDefault();
    return false;
  }
  document.getElementById('categoryname').classList.remove('is-invalid');
  return true;
}
</script>
</body>
</html>
