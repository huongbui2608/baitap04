package vn.iotstar.util;

import java.io.File;

public class Constant {
    /** Thư mục lưu ảnh upload. Tự tạo nếu chưa tồn tại. */
    public static final String DIR = "C:\\Users\\LOQ\\Documents\\Wep\\baitap01.2\\upload";

    static {
        File dir = new File(DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }
}
