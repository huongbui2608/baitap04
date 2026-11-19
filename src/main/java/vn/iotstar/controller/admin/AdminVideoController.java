package vn.iotstar.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.util.Constant;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50,              // 50MB
        maxRequestSize = 1024 * 1024 * 100)          // 100MB
@WebServlet(urlPatterns = { "/admin/videos", "/admin/video/add", "/admin/video/insert",
        "/admin/video/edit", "/admin/video/update", "/admin/video/delete" })
public class AdminVideoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IVideoService videoService = new VideoServiceImpl();
    private final ICategoryService cateService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String url = req.getRequestURI();
        if (url.contains("/admin/videos")) {
            List<Video> list = videoService.findAll();
            req.setAttribute("videoList", list);
            req.getRequestDispatcher("/views/admin/video-list.jsp").forward(req, resp);
        } else if (url.contains("/admin/video/add")) {
            List<Category> categories = cateService.findAll();
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
        } else if (url.contains("/admin/video/edit")) {
            String id = req.getParameter("id");
            Video video = videoService.findById(id);
            List<Category> categories = cateService.findAll();
            req.setAttribute("video", video);
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);
        } else if (url.contains("/admin/video/delete")) {
            String id = req.getParameter("id");
            try {
                videoService.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String url = req.getRequestURI();
        String uploadPath = Constant.DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        if (url.contains("/admin/video/insert")) {
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String videoUrl = req.getParameter("videoUrl");
            String posterUrl = req.getParameter("posterUrl");
            String categoryIdStr = req.getParameter("categoryId");
            boolean active = "1".equals(req.getParameter("active")) || "true".equalsIgnoreCase(req.getParameter("active")) || "on".equals(req.getParameter("active"));

            if (videoId == null || videoId.trim().isEmpty()) {
                videoId = "v_" + System.currentTimeMillis();
            } else {
                videoId = videoId.trim();
                // VALIDATION: Kiểm tra xem mã video đã tồn tại hay chưa
                Video existVideo = videoService.findById(videoId);
                if (existVideo != null) {
                    req.setAttribute("alert", "Mã Video '" + videoId + "' đã tồn tại! Vui lòng chọn một mã khác.");
                    req.setAttribute("categories", cateService.findAll());
                    req.setAttribute("videoId", videoId);
                    req.setAttribute("title", title);
                    req.setAttribute("description", description);
                    req.setAttribute("videoUrl", videoUrl);
                    req.setAttribute("posterUrl", posterUrl);
                    req.setAttribute("categoryId", categoryIdStr);
                    req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
                    return;
                }
            }

            // VALIDATION: Tiêu đề video tối thiểu 3 ký tự
            if (title == null || title.trim().length() < 3) {
                req.setAttribute("alert", "Tiêu đề video không được để trống và phải có ít nhất 3 ký tự!");
                req.setAttribute("categories", cateService.findAll());
                req.setAttribute("videoId", videoId);
                req.setAttribute("title", title);
                req.setAttribute("description", description);
                req.setAttribute("videoUrl", videoUrl);
                req.setAttribute("posterUrl", posterUrl);
                req.setAttribute("categoryId", categoryIdStr);
                req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
                return;
            }

            Video video = new Video();
            video.setVideoId(videoId);
            video.setTitle(title);
            video.setDescription(description);
            video.setActive(active);
            video.setViews(0);
            video.setCreatedAt(new Date());

            // Xử lý upload file Poster bằng Multipart Part
            try {
                Part posterPart = req.getPart("posterFile");
                if (posterPart != null && posterPart.getSize() > 0) {
                    String fileName = Paths.get(posterPart.getSubmittedFileName()).getFileName().toString();
                    String ext = fileName.contains(".") ? fileName.substring(fileName.lastIndexOf(".")) : ".jpg";
                    String savedName = "poster_" + System.currentTimeMillis() + ext;
                    posterPart.write(uploadPath + File.separator + savedName);
                    video.setPoster(savedName);
                } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                    video.setPoster(posterUrl.trim());
                } else {
                    video.setPoster("https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600");
                }
            } catch (Exception e) {
                e.printStackTrace();
                video.setPoster("https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600");
            }

            // Xử lý upload file Video (hoặc lấy link URL)
            try {
                Part videoPart = req.getPart("videoFile");
                if (videoPart != null && videoPart.getSize() > 0) {
                    String fileName = Paths.get(videoPart.getSubmittedFileName()).getFileName().toString();
                    String ext = fileName.contains(".") ? fileName.substring(fileName.lastIndexOf(".")) : ".mp4";
                    String savedName = "video_" + System.currentTimeMillis() + ext;
                    videoPart.write(uploadPath + File.separator + savedName);
                    video.setVideoUrl(savedName);
                } else if (videoUrl != null && !videoUrl.trim().isEmpty()) {
                    video.setVideoUrl(videoUrl.trim());
                } else {
                    video.setVideoUrl("https://www.w3schools.com/html/mov_bbb.mp4");
                }
            } catch (Exception e) {
                e.printStackTrace();
                video.setVideoUrl("https://www.w3schools.com/html/mov_bbb.mp4");
            }

            // Gắn Category
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    int cid = Integer.parseInt(categoryIdStr);
                    Category cat = cateService.findById(cid);
                    video.setCategory(cat);
                } catch (Exception ignored) {}
            }

            // Gắn User tạo video (từ Session)
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("account") != null) {
                vn.iotstar.model.User account = (vn.iotstar.model.User) session.getAttribute("account");
                User userEntity = new User();
                userEntity.setId(account.getId());
                video.setUser(userEntity);
            }

            videoService.insert(video);
            resp.sendRedirect(req.getContextPath() + "/admin/videos");

        } else if (url.contains("/admin/video/update")) {
            String videoId = req.getParameter("videoId");
            Video video = videoService.findById(videoId);

            if (video != null) {
                String title = req.getParameter("title");
                String description = req.getParameter("description");
                String videoUrl = req.getParameter("videoUrl");
                String posterUrl = req.getParameter("posterUrl");
                String categoryIdStr = req.getParameter("categoryId");
                boolean active = "1".equals(req.getParameter("active")) || "true".equalsIgnoreCase(req.getParameter("active")) || "on".equals(req.getParameter("active"));

                // VALIDATION: Tiêu đề video tối thiểu 3 ký tự
                if (title == null || title.trim().length() < 3) {
                    req.setAttribute("alert", "Tiêu đề video không được để trống và phải có ít nhất 3 ký tự!");
                    req.setAttribute("video", video);
                    req.setAttribute("categories", cateService.findAll());
                    req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);
                    return;
                }

                video.setTitle(title);
                video.setDescription(description);
                video.setActive(active);

                // Cập nhật poster
                try {
                    Part posterPart = req.getPart("posterFile");
                    if (posterPart != null && posterPart.getSize() > 0) {
                        String fileName = Paths.get(posterPart.getSubmittedFileName()).getFileName().toString();
                        String ext = fileName.contains(".") ? fileName.substring(fileName.lastIndexOf(".")) : ".jpg";
                        String savedName = "poster_" + System.currentTimeMillis() + ext;
                        posterPart.write(uploadPath + File.separator + savedName);
                        video.setPoster(savedName);
                    } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                        video.setPoster(posterUrl.trim());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Cập nhật video file/url
                try {
                    Part videoPart = req.getPart("videoFile");
                    if (videoPart != null && videoPart.getSize() > 0) {
                        String fileName = Paths.get(videoPart.getSubmittedFileName()).getFileName().toString();
                        String ext = fileName.contains(".") ? fileName.substring(fileName.lastIndexOf(".")) : ".mp4";
                        String savedName = "video_" + System.currentTimeMillis() + ext;
                        videoPart.write(uploadPath + File.separator + savedName);
                        video.setVideoUrl(savedName);
                    } else if (videoUrl != null && !videoUrl.trim().isEmpty()) {
                        video.setVideoUrl(videoUrl.trim());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Cập nhật Category
                if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                    try {
                        int cid = Integer.parseInt(categoryIdStr);
                        Category cat = cateService.findById(cid);
                        video.setCategory(cat);
                    } catch (Exception ignored) {}
                }

                videoService.update(video);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }
}
