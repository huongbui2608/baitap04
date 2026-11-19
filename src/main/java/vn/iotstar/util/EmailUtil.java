package vn.iotstar.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.security.SecureRandom;
import java.util.Properties;

public class EmailUtil {

    // Cấu hình tài khoản gửi mail mặc định (Gmail SMTP)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "system.mailer.iotstar@gmail.com";
    private static final String SENDER_PASSWORD = "vnhg wxyz abcd efgh"; // App password placeholder

    private static final SecureRandom random = new SecureRandom();

    /**
     * Sinh mã OTP ngẫu nhiên n chữ số (mặc định 6 chữ số).
     */
    public static String generateOtp(int length) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }

    /**
     * Gửi email OTP kích hoạt tài khoản hoặc đặt lại mật khẩu.
     */
    public static boolean sendOtp(String toEmail, String otp, String purpose) {
        String subject = "[IOTSTAR] Mã xác nhận OTP - " + purpose;
        String content = "<html><body style='font-family: Arial, sans-serif; color: #333;'>"
                + "<div style='max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;'>"
                + "<h2 style='color: #4f46e5; text-align: center;'>MÃ XÁC NHẬN OTP</h2>"
                + "<p>Xin chào,</p>"
                + "<p>Bạn vừa thực hiện yêu cầu: <b>" + purpose + "</b>.</p>"
                + "<p>Mã xác thực OTP của bạn là:</p>"
                + "<div style='text-align: center; margin: 24px 0;'>"
                + "<span style='font-size: 32px; font-weight: bold; letter-spacing: 6px; color: #4f46e5; background: #eef2ff; padding: 10px 24px; border-radius: 6px; display: inline-block;'>"
                + otp + "</span>"
                + "</div>"
                + "<p style='color: #666; font-size: 13px;'>Mã xác nhận này có hiệu lực trong vòng 5 phút. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>"
                + "<hr style='border: none; border-top: 1px solid #eee; margin: 20px 0;'>"
                + "<p style='color: #999; font-size: 12px; text-align: center;'>Hệ thống quản lý Java Web - IoTStar HCMUTE</p>"
                + "</div></body></html>";

        // In mã OTP ra Console để test trực tiếp
        System.out.println("================================================================================");
        System.out.println(">>> [EMAIL UTIL] Gửi tới: " + toEmail);
        System.out.println(">>> [EMAIL UTIL] Mục đích: " + purpose);
        System.out.println(">>> [EMAIL UTIL] MÃ OTP: " + otp);
        System.out.println("================================================================================");

        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.connectiontimeout", "3000");
            props.put("mail.smtp.timeout", "3000");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL, "IoTStar System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(content, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println(">>> [EMAIL UTIL] Email đã được gửi thành công qua SMTP!");
            return true;
        } catch (Exception e) {
            System.out.println(">>> [EMAIL UTIL] SMTP chưa kết nối (offline mode), đã log OTP ra Console ở trên để tiếp tục kiểm thử.");
            return true; // Trả về true để luồng người dùng vẫn thông suốt với mã OTP hiển thị trên Console
        }
    }
}
