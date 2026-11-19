package vn.iotstar.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Map;

/**
 * Tiện ích upload ảnh lên Cloudinary bằng Multipart (Yêu cầu 3).
 * Có cơ chế tự động fallback lưu cục bộ nếu không có kết nối internet để luôn hoạt động ổn định.
 */
public class CloudinaryUtil {

    // Cấu hình Cloudinary (Có thể thay đổi bằng tài khoản cá nhân của bạn)
    private static final String CLOUD_NAME = "dtzhe963z";
    private static final String API_KEY    = "721665798939598";
    private static final String API_SECRET = "UeI187-e2t0q-t0X7066jD5k8g4";

    private static Cloudinary cloudinary;

    static {
        try {
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", CLOUD_NAME,
                "api_key", API_KEY,
                "api_secret", API_SECRET,
                "secure", true
            ));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Upload ảnh lên Cloudinary từ byte array của file Multipart.
     * @param fileBytes Mảng byte của ảnh
     * @param originalFilename Tên file gốc
     * @return URL ảnh trực tuyến (https://res.cloudinary.com/...)
     */
    public static String uploadImage(byte[] fileBytes, String originalFilename) {
        if (fileBytes == null || fileBytes.length == 0) {
            return null;
        }

        try {
            if (cloudinary != null) {
                Map<?, ?> uploadResult = cloudinary.uploader().upload(fileBytes, ObjectUtils.asMap(
                    "folder", "users_profile",
                    "resource_type", "image"
                ));
                String secureUrl = (String) uploadResult.get("secure_url");
                if (secureUrl != null && !secureUrl.isEmpty()) {
                    System.out.println(">>> [CLOUDINARY] Upload thành công! URL: " + secureUrl);
                    return secureUrl;
                }
            }
        } catch (Exception e) {
            System.out.println(">>> [CLOUDINARY] Không kết nối được Cloudinary (chế độ offline), chuyển sang lưu cục bộ...");
        }

        // Fallback: Lưu vào thư mục upload cục bộ của máy
        try {
            String ext = originalFilename != null && originalFilename.contains(".")
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".jpg";
            String localFileName = "avatar_" + System.currentTimeMillis() + ext;
            File localFile = new File(Constant.DIR, localFileName);
            try (FileOutputStream fos = new FileOutputStream(localFile)) {
                fos.write(fileBytes);
            }
            return localFileName;
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }
}
