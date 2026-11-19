<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${sitemesh_title} - Admin Panel</title>

  <!-- Bootstrap 5.3.3 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <!-- Custom Project CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">

  ${sitemesh_head}

  <style>
    body {
      background-color: #f1f5f9;
      color: #0f172a;
      min-height: 100vh;
    }
    .admin-navbar {
      background: #1e293b;
    }
    .admin-sidebar {
      background: #0f172a;
      min-height: calc(100vh - 56px);
      color: #cbd5e1;
    }
    .admin-sidebar .nav-link {
      color: #94a3b8;
      padding: 12px 18px;
      font-weight: 500;
      border-radius: 6px;
      margin-bottom: 4px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .admin-sidebar .nav-link:hover, .admin-sidebar .nav-link.active {
      color: #fff;
      background: #334155;
    }
    .admin-content {
      padding: 24px;
    }
  </style>
</head>
<body>

  <!-- Admin Topbar -->
  <nav class="navbar navbar-expand-lg navbar-dark admin-navbar shadow-sm py-2">
    <div class="container-fluid px-3">
      <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/admin/home">
        <span class="badge bg-danger">ADMIN</span>
        <span>VideoHub Manager</span>
      </a>
      <div class="d-flex align-items-center gap-3 ms-auto">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light btn-sm" target="_blank">
          <i class="bi bi-box-arrow-up-right me-1"></i>Xem trang web
        </a>
        <div class="dropdown">
          <a class="text-white text-decoration-none dropdown-toggle d-flex align-items-center gap-2" href="#" role="button" data-bs-toggle="dropdown">
            <i class="bi bi-person-circle fs-5"></i>
            <span>${sessionScope.account != null ? sessionScope.account.userName : 'Admin'}</span>
          </a>
          <ul class="dropdown-menu dropdown-menu-end shadow">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-badge me-2"></i>Profile cá nhân</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
          </ul>
        </div>
      </div>
    </div>
  </nav>

  <div class="container-fluid">
    <div class="row">
      <!-- Admin Sidebar -->
      <nav class="col-md-3 col-lg-2 d-md-block admin-sidebar p-3">
        <div class="position-sticky">
          <ul class="nav flex-column">
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/admin/home">
                <i class="bi bi-speedometer2"></i> Dashboard
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/admin/videos">
                <i class="bi bi-camera-reels-fill"></i> Quản lý Video
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">
                <i class="bi bi-folder2-open"></i> Quản lý Category
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/video">
                <i class="bi bi-collection-play"></i> Video phía người dùng
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/profile">
                <i class="bi bi-person-gear"></i> Tài khoản & Hồ sơ
              </a>
            </li>
            <li class="nav-item mt-4">
              <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-left"></i> Đăng xuất
              </a>
            </li>
          </ul>
        </div>
      </nav>

      <!-- Main Admin Content Decorated by SiteMesh -->
      <main class="col-md-9 ms-sm-auto col-lg-10 admin-content">
        ${sitemesh_body}
      </main>
    </div>
  </div>

  <!-- Bootstrap 5.3.3 JS Bundle -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
