package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.util.Constant;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet(urlPatterns = { "/image", "/file", "/video-stream" })
public class DownloadImageController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String fname = req.getParameter("fname");

        // Chống path traversal
        if (fname == null || fname.trim().isEmpty() || fname.contains("..") || fname.contains("/") || fname.contains("\\")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tên file không hợp lệ");
            return;
        }

        File file = new File(Constant.DIR, fname);
        if (!file.exists() || !file.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy file");
            return;
        }

        // Xác định Content-Type theo phần mở rộng file (hỗ trợ cả ảnh và video)
        String lower = fname.toLowerCase();
        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) {
            resp.setContentType("image/jpeg");
        } else if (lower.endsWith(".png")) {
            resp.setContentType("image/png");
        } else if (lower.endsWith(".gif")) {
            resp.setContentType("image/gif");
        } else if (lower.endsWith(".webp")) {
            resp.setContentType("image/webp");
        } else if (lower.endsWith(".mp4")) {
            resp.setContentType("video/mp4");
        } else if (lower.endsWith(".webm")) {
            resp.setContentType("video/webm");
        } else if (lower.endsWith(".ogg")) {
            resp.setContentType("video/ogg");
        } else {
            resp.setContentType("application/octet-stream");
        }

        resp.setContentLengthLong(file.length());

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = resp.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
            os.flush();
        }
    }
}
