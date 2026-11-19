# BÀI TẬP 01 & 02 & 03 - JAVA WEB MVC2 & JPA 3.0 & VIDEO HUB (HCMUTE)
**Công nghệ:** Jakarta EE 11 (Servlet 6.1, JSP 4.0, JSTL 3.0), Hibernate ORM 6.6.1 (JPA 3.0/3.1), Apache Tomcat 11.0.25, Java 21/25 (LTS), SQL Server, Maven 3.9.x, BCrypt Hashing, Jakarta Mail (Angus Mail), SiteMesh Decorator 3, Cloudinary API, Bootstrap 5.3.3.

---

## 1. Danh sách yêu cầu đã hoàn thành

### Yêu cầu 1: Cấu hình SiteMesh Decorator 3 với Template Bootstrap (Hạn: trước 16g00 ngày 19/11/2026)
- **Cấu hình SiteMesh 3:** Khởi tạo file cấu hình chuẩn `src/main/webapp/WEB-INF/sitemesh3.xml` phân chia rõ ràng các vùng hiển thị:
  - Áp dụng decorator cho giao diện quản trị: `<mapping path="/admin/*" decorator="/decorators/admin.jsp"/>`.
  - Áp dụng decorator cho toàn bộ giao diện người dùng: `<mapping path="/*" decorator="/decorators/web.jsp"/>`.
  - Loại trừ các file tĩnh, ảnh, media stream: `<mapping path="/static/*" exclude="true"/>`, `/image*`, `/file*`, `/video-stream*`.
- **02 Template Bootstrap 5.3.3 Decorator:**
  - `src/main/webapp/decorators/web.jsp`: Template giao diện người dùng với Navbar responsive, Avatar profile dropdown, Footer hiện đại, tự động chèn nội dung con thông qua `<sitemesh:write property='body'/>` và `${sitemesh_body}`.
  - `src/main/webapp/decorators/admin.jsp`: Template giao diện Quản trị viên (Admin Panel) với Header bar, Sidebar điều hướng quản lý Video và Category, vùng Main Content.
- **Bộ lọc SiteMesh cho Jakarta EE 11:** Xây dựng `SiteMeshDecoratorFilter` (`jakarta.servlet.Filter`) tương thích 100% với Apache Tomcat 11 (Servlet 6.0/6.1), tự động parse head/title/body và loại bỏ các header trùng lặp.

---

### Yêu cầu 2: Thực hiện Validation cho những chức năng có FORM (Hạn: trước 16g00 ngày 19/11/2026)
Hệ thống được trang bị cơ chế **Validation kép (Client-side & Server-side)** toàn diện cho tất cả các form trong hệ thống:
1. **Form Đăng nhập (`/login`):**
   - *Client-side:* Kiểm tra form Bootstrap `needs-validation`, trường bắt buộc, tối thiểu 3 ký tự.
   - *Server-side:* Kiểm tra rỗng, độ dài tối thiểu, băm mật khẩu BCrypt, kiểm tra trạng thái kích hoạt tài khoản (`active = 1`).
2. **Form Đăng ký (`/register`):**
   - *Client-side:* Regex username `^[a-zA-Z0-9_]{3,30}$`, email chuẩn, số điện thoại Việt Nam `^(0|\+84)[3|5|7|8|9][0-9]{8}$`, mật khẩu tối thiểu 6 ký tự, kiểm tra trùng khớp mật khẩu theo thời gian thực (real-time feedback).
   - *Server-side:* Kiểm tra trùng username, trùng email, định dạng số điện thoại, băm BCrypt an toàn.
3. **Form Quên mật khẩu & Đặt lại mật khẩu (`/forgot-password`, `/reset-password`):**
   - *Client-side:* Kiểm tra email/username tối thiểu 3 ký tự, mã OTP đúng 6 chữ số `[0-9]{6}`, xác nhận mật khẩu mới.
   - *Server-side:* Kiểm tra tài khoản tồn tại trong DB, xác thực mã OTP khớp và còn hiệu lực, mật khẩu mới tối thiểu 6 ký tự.
4. **Form Thêm & Sửa Category (`/admin/category/add`, `/admin/category/edit`):**
   - *Client-side:* Bắt buộc nhập tên danh mục, độ dài tối thiểu 2 ký tự.
   - *Server-side:* Xử lý trong `CategoryController`, từ chối lưu và giữ lại dữ liệu nhập nếu tên rỗng hoặc dưới 2 ký tự.
5. **Form Thêm & Sửa Video (`/admin/video/add`, `/admin/video/edit`):**
   - *Client-side:* Kiểm tra mã Video ID (2-50 ký tự), bắt buộc nhập tiêu đề Video (tối thiểu 3 ký tự), bắt buộc chọn Category.
   - *Server-side:* Xử lý trong `AdminVideoController`, kiểm tra trùng mã `videoId` khi thêm mới, kiểm tra độ dài tiêu đề `title`.
6. **Form Cập nhật Hồ sơ User Profile (`/profile`):**
   - *Client-side:* Bắt buộc Họ tên (min 2 ký tự), kiểm tra định dạng Số điện thoại Việt Nam và Email.
   - *Server-side:* Kiểm tra trùng email với tài khoản khác, validate format trước khi xử lý đổi email.

---

### Yêu cầu 3: Chức năng Profile User, Upload ảnh Cloudinary Multipart & Đổi Email gửi OTP (Hạn: trước 12g30 ngày 23/11/2026)
- **Quản lý giao diện qua SiteMesh:** Trang `/profile` được quản lý và bọc tự động bởi template SiteMesh Decorator Bootstrap.
- **Cập nhật thông tin:** Cho phép người dùng cập nhật `fullname`, `phone`, `email`, và `avatar`.
- **Upload file lên Cloudinary bằng Multipart:**
  - Tích hợp thư viện `com.cloudinary:cloudinary-http44:1.36.0` cùng lớp `CloudinaryUtil.java`.
  - Servlet `ProfileController` nhận file ảnh thông qua `@MultipartConfig` (`avatarFile`), đọc mảng byte và upload lên Cloudinary thư mục `users_profile`.
  - Tự động lấy URL ảnh trực tuyến (`https://res.cloudinary.com/...`) lưu vào cột `avatar` bảng `[User]` (được cấu hình `NVARCHAR(500)`).
  - Có cơ chế Fallback tự động lưu file cục bộ vào `Constant.DIR` khi ngoại tuyến hoặc máy chấm bài bị chặn mạng ngoài.
  - Xem trước ảnh đại diện (Preview) bằng JavaScript ngay khi người dùng chọn file từ máy tính.
- **Đổi Email mới gửi mã xác nhận OTP:**
  - Khi người dùng nhập một địa chỉ email mới khác với email hiện tại, hệ thống:
    1. Kiểm tra xem email mới đã có người khác đăng ký chưa.
    2. Cập nhật trước thông tin họ tên, số điện thoại, avatar.
    3. Tự động sinh mã OTP 6 số và gửi qua địa chỉ **email mới** (đồng thời log ra console server để test).
    4. Chuyển hướng người dùng sang trang `/profile/verify-email`.
    5. Sau khi người dùng nhập đúng mã OTP gửi đến email mới, hệ thống chính thức cập nhật email mới vào CSDL và cập nhật lại phiên đăng nhập.

---

### Yêu cầu bổ sung đã hoàn thành từ các giai đoạn trước:
- Kích hoạt tài khoản bằng mã OTP 6 số gửi qua email (`/register` -> `/verify-otp`).
- Đăng nhập bảo mật với hàm băm BCrypt + Cookie 30 phút (`/login`, `/logout`).
- Quên mật khẩu gửi OTP đặt lại mật khẩu (`/forgot-password`, `/reset-password`).
- Bảng `videos` quan hệ 1 - n với `[User]` và `Category`.
- CRUD Video với chuẩn Jakarta Servlet 6.0 `@MultipartConfig`.
- Hiển thị Top 10 Video mới nhất tại trang chủ `/home`.
- Phân trang hiển thị chính xác 6 video/trang tại `/video`.
- Xem chi tiết và phát video (HTML5 `<video>` & YouTube `<iframe>`) tại `/video/detail`.

---

## 2. Cấu trúc thư mục dự án `baitap01.2`
```
baitap01.2/
├── pom.xml                               # Cấu hình Maven (release 21, Hibernate ORM 6.6.1, sitemesh, cloudinary, jbcrypt, jakarta.mail)
├── .gitignore                            # Loại trừ target/, upload/, .settings/, .classpath, .project
├── README.md                             # Tài liệu hướng dẫn chi tiết
├── database/
│   └── script.sql                        # Script CSDL ShoppingServiceMVC ([User], Category, videos, dữ liệu mẫu)
├── upload/                               # Thư mục lưu ảnh và video upload
└── src/
    └── main/
        ├── resources/
        │   └── META-INF/
        │       └── persistence.xml       # Cấu hình JPA 3.0 với User, Category, Video
        ├── java/
        │   └── vn/iotstar/
        │       ├── config/
        │       │   └── JpaConfig.java    # Khởi tạo EntityManagerFactory
        │       ├── connection/
        │       │   └── DBConnection.java # Kết nối SQL Server qua JDBC
        │       ├── entity/
        │       │   ├── User.java         # JPA Entity User (1 - n với Video)
        │       │   ├── Category.java     # JPA Entity Category (1 - n với Video)
        │       │   └── Video.java        # JPA Entity Video (n - 1 với User & Category)
        │       ├── model/
        │       │   ├── User.java         # Model User (active, code OTP, avatar, roleid)
        │       │   └── Category.java     # Model Category
        │       ├── dao/
        │       │   ├── IUserDao.java     # Interface DAO User (OTP, updateProfile, updateEmail)
        │       │   ├── ICategoryDao.java # Interface DAO Category (JPA)
        │       │   ├── IVideoDao.java    # Interface DAO Video (JPA, top 10, phân trang 6 sp)
        │       │   └── impl/
        │       │       ├── UserDaoImpl.java
        │       │       ├── CategoryDao.java
        │       │       └── VideoDao.java
        │       ├── service/
        │       │   ├── IUserService.java # Service User (login, register, updateProfile, email OTP)
        │       │   ├── ICategoryService.java
        │       │   ├── IVideoService.java
        │       │   └── impl/
        │       │       ├── UserServiceImpl.java
        │       │       ├── CategoryServiceImpl.java
        │       │       └── VideoServiceImpl.java
        │       ├── controller/
        │       │   ├── HomeController.java          # / và /home (Top 10 video mới nhất)
        │       │   ├── LoginController.java         # /login (Bảo mật BCrypt, Validation)
        │       │   ├── LogoutController.java        # /logout
        │       │   ├── RegisterController.java      # /register (Gửi OTP, Validation)
        │       │   ├── VerifyOtpController.java     # /verify-otp (Xác thực OTP đăng ký)
        │       │   ├── ForgotPasswordController.java# /forgot-password (Validation)
        │       │   ├── ResetPasswordController.java # /reset-password (Validation)
        │       │   ├── ProfileController.java       # /profile & /profile/verify-email (Cloudinary & OTP)
        │       │   ├── VideoPlayerController.java   # /video (Phân trang 6 video) & /video/detail
        │       │   ├── DownloadImageController.java # /image & /file
        │       │   ├── WaitingController.java       # /waiting
        │       │   └── admin/
        │       │       ├── AdminHomeController.java # /admin/home
        │       │       ├── AdminVideoController.java# /admin/videos (CRUD Video + Validation)
        │       │       └── CategoryController.java  # /admin/categories (CRUD Category + Validation)
        │       ├── filter/
        │       │   ├── AuthFilter.java              # Bảo vệ /admin/* và /manager/*
        │       │   └── SiteMeshDecoratorFilter.java # Bộ lọc Decorator Jakarta EE 11 Bootstrap
        │       └── util/
        │           ├── Constant.java                # Đường dẫn upload
        │           ├── PasswordUtil.java            # Băm mật khẩu BCrypt
        │           ├── EmailUtil.java               # Gửi mail OTP & in log console
        │           └── CloudinaryUtil.java          # Upload ảnh Cloudinary bằng Multipart & Fallback
        └── webapp/
            ├── index.jsp                            # Forward sang /home
            ├── static/css/style.css                 # Giao diện responsive
            ├── WEB-INF/
            │   ├── web.xml
            │   └── sitemesh3.xml                    # Cấu hình SiteMesh Decorator 3
            ├── decorators/
            │   ├── web.jsp                          # Bootstrap 5 Decorator Template cho Web
            │   └── admin.jsp                        # Bootstrap 5 Decorator Template cho Admin
            └── views/
                ├── topbar.jsp
                ├── home.jsp                         # Trang chủ (Top 10 Video)
                ├── login.jsp                        # Đăng nhập (Bootstrap Validation)
                ├── register.jsp                     # Đăng ký (Bootstrap Validation)
                ├── verify-otp.jsp                   # Xác thực OTP kích hoạt
                ├── forgot-password.jsp              # Quên mật khẩu (Bootstrap Validation)
                ├── reset-password.jsp               # Đặt lại mật khẩu (Bootstrap Validation)
                ├── profile.jsp                      # Profile cá nhân (Cloudinary upload & Bootstrap)
                ├── verify-email.jsp                 # Nhập OTP xác thực email mới
                ├── video-list.jsp                   # Phân trang 6 video/trang
                ├── video-detail.jsp                 # Chi tiết & phát video
                └── admin/
                    ├── home.jsp
                    ├── video-list.jsp
                    ├── video-add.jsp                # Thêm video (Bootstrap Validation)
                    ├── video-edit.jsp               # Sửa video (Bootstrap Validation)
                    ├── category-list.jsp
                    ├── category-add.jsp             # Thêm danh mục (Bootstrap Validation)
                    └── category-edit.jsp            # Sửa danh mục (Bootstrap Validation)
```

---

## 3. Hướng dẫn chạy và kiểm thử

### Bước 1: Khởi động SQL Server
Chạy file script `database/script.sql` trong SQL Server Management Studio (SSMS) để đảm bảo bảng `[User]` có cột `avatar NVARCHAR(500)`.

Tài khoản mặc định:
- **Admin:** `admin` / `123` (Role 1)
- **User:** `user` / `123` (Role 5)

### Bước 2: Đóng gói ứng dụng WAR
Mở terminal tại thư mục `baitap01.2` và chạy:
```powershell
mvn clean package
```
Kết quả tạo ra file `target/baitap01.war`.

### Bước 3: Triển khai lên Apache Tomcat 11
Copy file `target/baitap01.war` vào thư mục `webapps` của Tomcat:
```powershell
copy target\baitap01.war C:\Users\LOQ\Documents\Wep\apache-tomcat-11.0.25\webapps\baitap01.war
```

### Bước 4: Kiểm thử các chức năng qua trình duyệt
1. **SiteMesh Decorator 3 Template Bootstrap:**
   - Truy cập bất kỳ trang nào như `http://localhost:8080/baitap01/home` hoặc `http://localhost:8080/baitap01/video`.
   - Toàn bộ giao diện tự động bọc bởi thanh Navbar Bootstrap 5.3, Menu điều hướng, Avatar góc phải và Footer.
   - Các trang Quản trị `http://localhost:8080/baitap01/admin/videos` tự động bọc bởi Admin Sidebar Panel.
2. **Kiểm thử Validation trên các Form:**
   - Thử gửi form rỗng hoặc nhập dữ liệu sai định dạng tại: `/login`, `/register`, `/forgot-password`, `/reset-password`, `/admin/category/add`, `/admin/video/add`, `/profile`.
   - Hệ thống hiển thị cảnh báo invalid-feedback màu đỏ và ngăn chặn submit, đồng thời server-side validate an toàn.
3. **Kiểm thử Hồ Sơ Profile, Cloudinary Upload & Đổi Email gửi OTP:**
   - Đăng nhập tài khoản và bấm vào tên người dùng ở góc phải Navbar -> chọn **Hồ sơ (Profile)** (hoặc truy cập `http://localhost:8080/baitap01/profile`).
   - **Upload avatar lên Cloudinary:** Chọn 1 file ảnh từ máy tính -> ảnh được xem trước ngay lập tức. Bấm "Lưu Thay Đổi", hệ thống upload file bằng multipart lên Cloudinary và lưu link URL `https://res.cloudinary.com/...` vào CSDL.
   - **Đổi Email gửi OTP:** Đổi địa chỉ email sang một email khác và bấm "Lưu Thay Đổi". Hệ thống tự động chuyển sang trang `/profile/verify-email` và gửi mã OTP 6 số đến email mới (mã cũng được hiển thị tại server console). Nhập đúng mã OTP để hoàn tất đổi email.
