-- Script tạo database ShoppingServiceMVC cho Bài tập 01 & 02 & Video Upload
-- Hỗ trợ chạy nhiều lần nhờ kiểm tra IF NOT EXISTS

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ShoppingServiceMVC')
BEGIN
    CREATE DATABASE ShoppingServiceMVC;
END
GO

USE ShoppingServiceMVC;
GO

-- 1. Bảng [User] với chức năng OTP kích hoạt và quên mật khẩu
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'User')
BEGIN
    CREATE TABLE [User] (
        id          INT IDENTITY(1,1) PRIMARY KEY,
        email       NVARCHAR(255),
        username    NVARCHAR(100) NOT NULL UNIQUE,
        fullname    NVARCHAR(255),
        password    NVARCHAR(255),
        avatar      NVARCHAR(255),
        roleid      INT DEFAULT 5,
        phone       NVARCHAR(20),
        createdDate DATE,
        active      BIT DEFAULT 1,
        code        NVARCHAR(50) NULL
    );
END
ELSE
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='User' AND COLUMN_NAME='active')
        ALTER TABLE [User] ADD active BIT DEFAULT 1;
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='User' AND COLUMN_NAME='code')
        ALTER TABLE [User] ADD code NVARCHAR(50) NULL;
END
GO

-- 2. Bảng Category
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Category')
BEGIN
    CREATE TABLE Category (
        cate_id   INT IDENTITY(1,1) PRIMARY KEY,
        cate_name NVARCHAR(255) NOT NULL,
        icons     NVARCHAR(255) NULL
    );
END
GO

-- 3. Bảng videos (Quan hệ 1 - n với bảng [User] và Category)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'videos')
BEGIN
    CREATE TABLE videos (
        videoId     NVARCHAR(50) PRIMARY KEY,
        title       NVARCHAR(255) NOT NULL,
        poster      NVARCHAR(500) NULL,
        videoUrl    NVARCHAR(500) NULL,
        views       INT DEFAULT 0,
        description NVARCHAR(MAX) NULL,
        active      BIT DEFAULT 1,
        userId      INT NULL,
        categoryId  INT NULL,
        createdAt   DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_videos_user FOREIGN KEY (userId) REFERENCES [User](id) ON DELETE SET NULL,
        CONSTRAINT FK_videos_category FOREIGN KEY (categoryId) REFERENCES Category(cate_id) ON DELETE SET NULL
    );
END
GO

-- Dữ liệu mẫu User
IF NOT EXISTS (SELECT 1 FROM [User] WHERE username = 'admin')
BEGIN
    INSERT INTO [User] (email, username, fullname, password, avatar, roleid, phone, createdDate, active)
    VALUES ('admin@example.com', 'admin', N'Quản trị viên', '123', NULL, 1, '0901000001', CAST(GETDATE() AS DATE), 1);
END

IF NOT EXISTS (SELECT 1 FROM [User] WHERE username = 'manager')
BEGIN
    INSERT INTO [User] (email, username, fullname, password, avatar, roleid, phone, createdDate, active)
    VALUES ('manager@example.com', 'manager', N'Quản lý', '123', NULL, 2, '0901000002', CAST(GETDATE() AS DATE), 1);
END

IF NOT EXISTS (SELECT 1 FROM [User] WHERE username = 'user')
BEGIN
    INSERT INTO [User] (email, username, fullname, password, avatar, roleid, phone, createdDate, active)
    VALUES ('user@example.com', 'user', N'Người dùng', '123', NULL, 5, '0901000003', CAST(GETDATE() AS DATE), 1);
END
GO

-- Dữ liệu mẫu Category
IF NOT EXISTS (SELECT 1 FROM Category WHERE cate_name = N'Điện thoại')
BEGIN
    INSERT INTO Category (cate_name, icons) VALUES (N'Điện thoại', NULL);
    INSERT INTO Category (cate_name, icons) VALUES (N'Máy tính bảng', NULL);
    INSERT INTO Category (cate_name, icons) VALUES (N'Laptop', NULL);
    INSERT INTO Category (cate_name, icons) VALUES (N'Phụ kiện', NULL);
END
GO

-- Dữ liệu mẫu Videos
IF NOT EXISTS (SELECT 1 FROM videos WHERE videoId = 'v01')
BEGIN
    INSERT INTO videos (videoId, title, poster, videoUrl, views, description, active, userId, categoryId) VALUES
    ('v01', N'Hướng dẫn Lập trình Web với Java Servlet & JSP', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 1250, N'Video hướng dẫn xây dựng ứng dụng web với Java Servlet và JSP từ cơ bản đến nâng cao.', 1, 1, 1),
    ('v02', N'Xây dựng RESTful API với Spring Boot & Hibernate', 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 980, N'Hướng dẫn chi tiết tạo REST API, kết nối database SQL Server với JPA Hibernate.', 1, 1, 1),
    ('v03', N'Giới thiệu kiến trúc MVC2 trong Java Web', 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 750, N'Mô hình Model-View-Controller 2 giải thích tường minh, phân tách Controller và DAO.', 1, 1, 1),
    ('v04', N'Upload file trong Servlet 6.0 với @MultipartConfig', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 1120, N'Xử lý upload ảnh poster và video clip bằng Jakarta Servlet 6 @MultipartConfig.', 1, 1, 2),
    ('v05', N'Bảo mật mật khẩu với thuật toán băm BCrypt', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 640, N'Tại sao không nên lưu mật khẩu dạng plaintext? Cách dùng BCrypt trong Java.', 1, 1, 2),
    ('v06', N'Gửi mã xác nhận OTP kích hoạt tài khoản qua Email', 'https://images.unsplash.com/photo-1579203433502-03587a4b7207?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 890, N'Tích hợp Jakarta Mail gửi email chứa mã OTP 6 số để kích hoạt tài khoản đăng ký.', 1, 1, 2),
    ('v07', N'Quên mật khẩu và đặt lại mật khẩu an toàn', 'https://images.unsplash.com/photo-1618042164219-62c820f10723?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 530, N'Quy trình Forgot Password xác nhận OTP qua email gửi link/mã đặt lại mật khẩu mới.', 1, 1, 3),
    ('v08', N'Phân trang danh sách dữ liệu trong JSP Servlet', 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 420, N'Kỹ thuật phân trang 6 sản phẩm / trang với JPQL setFirstResult và setMaxResults.', 1, 1, 3),
    ('v09', N'Thiết kế giao diện người dùng hiện đại với Bootstrap 5', 'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 310, N'Giao diện responsive, thân thiện trên mobile và desktop cho website video sharing.', 1, 1, 4),
    ('v10', N'Deploy ứng dụng Java Web WAR lên Apache Tomcat 11', 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 990, N'Đóng gói file WAR bằng Maven và deploy lên Tomcat 11 trên Windows Server.', 1, 1, 4),
    ('v11', N'Tối ưu hóa hiệu năng truy vấn Hibernate và JPA 3.0', 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 680, N'Tránh lỗi N+1 query và tối ưu hóa bộ nhớ đệm Hibernate L2 Cache.', 1, 1, 1),
    ('v12', N'Xây dựng hệ thống bình luận và đánh giá video', 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=600', 'https://www.w3schools.com/html/mov_bbb.mp4', 510, N'Cho phép người dùng tương tác, thả tim và thảo luận dưới từng video.', 1, 1, 1);
END
GO
