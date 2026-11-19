package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.Video;
import vn.iotstar.model.User;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.VideoServiceImpl;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = { "/video", "/video/detail" })
public class VideoPlayerController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String uri = req.getRequestURI();

        // 4.4: Chi tiết và phát 01 video
        if (uri.endsWith("/video/detail")) {
            String videoId = req.getParameter("id");
            if (videoId == null || videoId.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/video");
                return;
            }

            // Tăng lượt view cho video
            videoService.increaseViews(videoId.trim());

            Video video = videoService.findById(videoId.trim());
            if (video == null) {
                resp.sendRedirect(req.getContextPath() + "/video");
                return;
            }

            List<Video> relatedVideos = videoService.findTop10Newest();
            req.setAttribute("video", video);
            req.setAttribute("relatedVideos", relatedVideos);
            req.getRequestDispatcher("/views/video-detail.jsp").forward(req, resp);
            return;
        }

        // 4.3: Hiển thị tất cả video của user và được phân trang 6sp/trang trên URL /video
        int page = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
        }

        int pageSize = 6; // 6 video / trang theo đúng yêu cầu
        int totalVideos = 0;
        int totalPages = 1;
        List<Video> videoList;

        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("account") : null;

        if (currentUser != null) {
            // Lấy video của user đang đăng nhập
            totalVideos = videoService.countByUserId(currentUser.getId());
            totalPages = (int) Math.ceil((double) totalVideos / pageSize);
            if (totalPages == 0) totalPages = 1;
            if (page > totalPages) page = totalPages;

            videoList = videoService.findByUserId(currentUser.getId(), page - 1, pageSize);
            req.setAttribute("isUserVideos", true);
            req.setAttribute("currentUser", currentUser);
        } else {
            // Nếu chưa đăng nhập, hiển thị tất cả video công khai phân trang 6 sp/trang
            totalVideos = videoService.count();
            totalPages = (int) Math.ceil((double) totalVideos / pageSize);
            if (totalPages == 0) totalPages = 1;
            if (page > totalPages) page = totalPages;

            videoList = videoService.findAll(page - 1, pageSize);
            req.setAttribute("isUserVideos", false);
        }

        req.setAttribute("videoList", videoList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalVideos", totalVideos);

        req.getRequestDispatcher("/views/video-list.jsp").forward(req, resp);
    }
}
