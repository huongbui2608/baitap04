<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><sitemesh:write property='title'/> - VideoHub & IoTStar</title>

  <!-- Bootstrap 5.3.3 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <!-- Custom Project CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">

  <sitemesh:write property='head'/>
  ${sitemesh_head}

  <style>
    body {
      background-color: #f8fafc;
      color: #1e293b;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }
    .navbar-brand-custom {
      font-weight: 800;
      font-size: 1.4rem;
      background: linear-gradient(135deg, #4f46e5, #9333ea);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    .avatar-sm {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      object-fit: cover;
      border: 2px solid #6366f1;
    }
    .footer-custom {
      margin-top: auto;
      background: #0f172a;
      color: #94a3b8;
      padding: 24px 0;
      font-size: 0.9rem;
    }
  </style>
</head>
<body>

  <!-- Header & Navigation Bar (Bootstrap 5 Template) -->
  <header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm py-2">
      <div class="container">
        <a class="navbar-brand navbar-brand-custom d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/home">
          <span>🎬</span>
          <span style="-webkit-text-fill-color: #fff;">VideoHub</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item">
              <a class="nav-link active" href="${pageContext.request.contextPath}/home"><i class="bi bi-house-door-fill me-1"></i>Trang chủ</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/video"><i class="bi bi-collection-play-fill me-1"></i>Video của tôi</a>
            </li>
            <c:if test="${sessionScope.account != null}">
              <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-circle me-1"></i>Hồ sơ (Profile)</a>
              </li>
              <c:if test="${sessionScope.account.roleid == 1}">
                <li class="nav-item dropdown">
                  <a class="nav-link dropdown-toggle text-warning" href="#" role="button" data-bs-toggle="dropdown">
                    <i class="bi bi-shield-lock-fill me-1"></i>Quản trị
                  </a>
                  <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/videos"><i class="bi bi-film me-2"></i>Quản lý Video</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="bi bi-folder-fill me-2"></i>Quản lý Category</a></li>
                  </ul>
                </li>
              </c:if>
            </c:if>
          </ul>

          <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center gap-2">
            <c:choose>
              <c:when test="${sessionScope.account != null}">
                <li class="nav-item dropdown">
                  <a class="nav-link dropdown-toggle d-flex align-items-center gap-2 text-white" href="#" role="button" data-bs-toggle="dropdown">
                    <c:choose>
                      <c:when test="${not empty sessionScope.account.avatar}">
                        <img src="${sessionScope.account.avatar}" alt="Avatar" class="avatar-sm">
                      </c:when>
                      <c:otherwise>
                        <div class="avatar-sm d-flex align-items-center justify-content-center bg-primary text-white fw-bold">
                          ${sessionScope.account.userName.substring(0,1).toUpperCase()}
                        </div>
                      </c:otherwise>
                    </c:choose>
                    <span>${sessionScope.account.fullName != null && !sessionScope.account.fullName.isEmpty() ? sessionScope.account.fullName : sessionScope.account.userName}</span>
                  </a>
                  <ul class="dropdown-menu dropdown-menu-end shadow">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-badge me-2"></i>Thông tin cá nhân</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/video"><i class="bi bi-play-circle me-2"></i>Video đã đăng</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
                  </ul>
                </li>
              </c:when>
              <c:otherwise>
                <li class="nav-item">
                  <a class="btn btn-outline-light btn-sm px-3" href="${pageContext.request.contextPath}/login"><i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập</a>
                </li>
                <li class="nav-item">
                  <a class="btn btn-primary btn-sm px-3" href="${pageContext.request.contextPath}/register"><i class="bi bi-person-plus me-1"></i>Đăng ký</a>
                </li>
              </c:otherwise>
            </c:choose>
          </ul>
        </div>
      </div>
    </nav>
  </header>

  <!-- Main Content Decorated by SiteMesh 3 -->
  <main class="py-4 flex-grow-1">
    <sitemesh:write property='body'/>
    ${sitemesh_body}
  </main>

  <!-- Footer (Bootstrap 5 Template) -->
  <footer class="footer-custom">
    <div class="container text-center">
      <div class="row align-items-center">
        <div class="col-md-6 text-md-start mb-2 mb-md-0">
          <span class="fw-bold text-white">🎬 VideoHub MVC2 & JPA 3.0</span> - Khoa CNTT HCMUTE
        </div>
        <div class="col-md-6 text-md-end">
          <span>Hệ thống quản lý Video & Tài khoản xác thực OTP | Sitemesh 3 & Bootstrap 5</span>
        </div>
      </div>
    </div>
  </footer>

  <!-- Bootstrap 5.3.3 JS Bundle -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
