package vn.iotstar.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    /**
     * Băm mật khẩu bằng BCrypt (salt rounds = 12).
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null) {
            return null;
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * Kiểm tra mật khẩu thường với mật khẩu đã lưu trong database.
     * Hỗ trợ cả mật khẩu băm BCrypt ($2a$, $2b$, $2y$) lẫn mật khẩu plaintext cũ.
     */
    public static boolean checkPassword(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null) {
            return false;
        }
        try {
            if (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$")) {
                return BCrypt.checkpw(plainPassword, storedPassword);
            }
        } catch (Exception e) {
            // Trường hợp chuỗi bắt đầu bằng $2 nhưng không đúng định dạng BCrypt
        }
        // Fallback: nếu mật khẩu cũ trong database chưa được băm (ví dụ: '123')
        return plainPassword.equals(storedPassword);
    }
}
