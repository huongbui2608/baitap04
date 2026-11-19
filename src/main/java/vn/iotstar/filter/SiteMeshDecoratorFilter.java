package vn.iotstar.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Filter áp dụng cấu hình SiteMesh Decorator 3 với Template Bootstrap (Yêu cầu 1).
 * Tự động bọc giao diện các trang con vào Decorator Template (/decorators/web.jsp hoặc /decorators/admin.jsp).
 */
@WebFilter(filterName = "SiteMeshDecoratorFilter", urlPatterns = "/*")
public class SiteMeshDecoratorFilter implements Filter {

    private static final Pattern TITLE_PATTERN = Pattern.compile("<title>(.*?)</title>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
    private static final Pattern HEAD_PATTERN = Pattern.compile("<head>(.*?)</head>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
    private static final Pattern BODY_PATTERN = Pattern.compile("<body[^>]*>(.*?)</body>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getServletPath();

        // Loại trừ các tài nguyên tĩnh, decorator nội bộ và API file/stream
        if (isExcluded(path)) {
            chain.doFilter(request, response);
            return;
        }

        CharResponseWrapper responseWrapper = new CharResponseWrapper(resp);
        chain.doFilter(request, responseWrapper);

        String originalHtml = responseWrapper.getCapturedHtml();

        // Chỉ decorate nếu response có nội dung HTML hợp lệ và không phải redirect
        if (originalHtml != null && !originalHtml.isEmpty() && resp.getStatus() < 300 && isHtmlContent(originalHtml)) {
            String title = extract(TITLE_PATTERN, originalHtml);
            String head = extract(HEAD_PATTERN, originalHtml);
            String body = extract(BODY_PATTERN, originalHtml);

            if (body.isEmpty()) {
                body = originalHtml;
            }

            // Loại bỏ thanh topbar cũ nếu có để tránh hiển thị trùng với navbar Bootstrap Decorator
            body = body.replaceAll("<nav class=['\"]topbar['\"][\\s\\S]*?</nav>", "");

            req.setAttribute("sitemesh_title", title.isEmpty() ? "VideoHub" : title);
            req.setAttribute("sitemesh_head", head);
            req.setAttribute("sitemesh_body", body);

            // Chọn decorator phù hợp (admin hoặc web)
            String decoratorPath = path.startsWith("/admin") ? "/decorators/admin.jsp" : "/decorators/web.jsp";

            // Bắt đầu render decorator template
            CharResponseWrapper decoratorWrapper = new CharResponseWrapper(resp);
            req.getRequestDispatcher(decoratorPath).include(req, decoratorWrapper);

            String decoratedHtml = decoratorWrapper.getCapturedHtml();

            // Thay thế các thẻ <sitemesh:write property='...'/> nếu còn tồn tại trong JSP
            decoratedHtml = decoratedHtml.replaceAll("<sitemesh:write\\s+property=['\"]title['\"]\\s*/>", Matcher.quoteReplacement(title))
                                         .replaceAll("<sitemesh:write\\s+property=['\"]head['\"]\\s*/>", Matcher.quoteReplacement(head))
                                         .replaceAll("<sitemesh:write\\s+property=['\"]body['\"]\\s*/>", Matcher.quoteReplacement(body));

            byte[] bytes = decoratedHtml.getBytes(StandardCharsets.UTF_8);
            resp.setContentType("text/html; charset=UTF-8");
            resp.setContentLength(bytes.length);
            resp.getOutputStream().write(bytes);
            resp.getOutputStream().flush();
        } else {
            // Viết trực tiếp nội dung gốc nếu không áp dụng decorator
            if (originalHtml != null) {
                byte[] bytes = originalHtml.getBytes(StandardCharsets.UTF_8);
                resp.getOutputStream().write(bytes);
                resp.getOutputStream().flush();
            }
        }
    }

    private boolean isExcluded(String path) {
        if (path == null) return true;
        return path.startsWith("/static/") ||
               path.startsWith("/image") ||
               path.startsWith("/file") ||
               path.startsWith("/video-stream") ||
               path.startsWith("/decorators/") ||
               path.endsWith(".css") ||
               path.endsWith(".js") ||
               path.endsWith(".png") ||
               path.endsWith(".jpg") ||
               path.endsWith(".jpeg") ||
               path.endsWith(".mp4") ||
               path.endsWith(".webm");
    }

    private boolean isHtmlContent(String content) {
        String lower = content.toLowerCase();
        return lower.contains("<html") || lower.contains("<!doctype html") || lower.contains("<body");
    }

    private String extract(Pattern pattern, String content) {
        Matcher matcher = pattern.matcher(content);
        if (matcher.find()) {
            return matcher.group(1).trim();
        }
        return "";
    }

    private static class CharResponseWrapper extends HttpServletResponseWrapper {
        private final ByteArrayOutputStream capture;
        private ServletOutputStream output;
        private PrintWriter writer;

        public CharResponseWrapper(HttpServletResponse response) {
            super(response);
            this.capture = new ByteArrayOutputStream();
        }

        @Override
        public ServletOutputStream getOutputStream() {
            if (writer != null) {
                throw new IllegalStateException("getWriter() already called.");
            }
            if (output == null) {
                output = new ServletOutputStream() {
                    @Override
                    public boolean isReady() { return true; }
                    @Override
                    public void setWriteListener(WriteListener writeListener) {}
                    @Override
                    public void write(int b) { capture.write(b); }
                    @Override
                    public void write(byte[] b, int off, int len) { capture.write(b, off, len); }
                };
            }
            return output;
        }

        @Override
        public PrintWriter getWriter() {
            if (output != null) {
                throw new IllegalStateException("getOutputStream() already called.");
            }
            if (writer == null) {
                writer = new PrintWriter(new OutputStreamWriter(capture, StandardCharsets.UTF_8));
            }
            return writer;
        }

        public String getCapturedHtml() {
            if (writer != null) {
                writer.flush();
            }
            return capture.toString(StandardCharsets.UTF_8);
        }
    }
}
