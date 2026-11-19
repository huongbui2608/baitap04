package vn.iotstar.service.impl;

import vn.iotstar.dao.IUserDao;
import vn.iotstar.dao.impl.UserDaoImpl;
import vn.iotstar.model.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.PasswordUtil;

import java.sql.Date;
import java.time.LocalDate;

public class UserServiceImpl implements IUserService {
    private final IUserDao userDao = new UserDaoImpl();

    @Override
    public User login(String username, String password) {
        User user = userDao.get(username);
        if (user == null) {
            user = userDao.getByEmail(username);
        }

        if (user != null) {
            boolean passwordMatch = PasswordUtil.checkPassword(password, user.getPassWord());
            if (passwordMatch) {
                // Tự động nâng cấp mật khẩu plaintext cũ thành chuỗi băm BCrypt
                if (user.getPassWord() != null && !user.getPassWord().startsWith("$2")) {
                    String newHash = PasswordUtil.hashPassword(password);
                    userDao.updatePassword(user.getId(), newHash);
                    user.setPassWord(newHash);
                }
                return user;
            }
        }
        return null;
    }

    @Override
    public User get(String username) {
        return userDao.get(username);
    }

    @Override
    public User getByEmail(String email) {
        return userDao.getByEmail(email);
    }

    @Override
    public boolean insert(User user) {
        if (user.getPassWord() != null && !user.getPassWord().startsWith("$2")) {
            user.setPassWord(PasswordUtil.hashPassword(user.getPassWord()));
        }
        return userDao.insert(user);
    }

    @Override
    public boolean register(String username, String password, String email, String fullname, String phone, String otp) {
        if (userDao.checkExistUsername(username)) return false;

        User user = new User();
        user.setUserName(username);
        user.setPassWord(PasswordUtil.hashPassword(password));
        user.setEmail(email);
        user.setFullName(fullname);
        user.setPhone(phone);
        user.setRoleid(5);
        user.setCreatedDate(Date.valueOf(LocalDate.now()));
        user.setActive(0);
        user.setCode(otp);

        boolean ok = userDao.insert(user);
        if (ok && email != null && !email.trim().isEmpty()) {
            EmailUtil.sendOtp(email, otp, "Kích hoạt tài khoản đăng ký mới");
        }
        return ok;
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }

    @Override
    public boolean checkExistPhone(String phone) {
        return userDao.checkExistPhone(phone);
    }

    @Override
    public boolean verifyOtp(String emailOrUsername, String otp) {
        User user = userDao.get(emailOrUsername);
        if (user == null) {
            user = userDao.getByEmail(emailOrUsername);
        }
        if (user != null && otp != null && otp.trim().equals(user.getCode())) {
            return userDao.activateUser(emailOrUsername);
        }
        return false;
    }

    @Override
    public boolean sendForgotPasswordOtp(String emailOrUsername) {
        User user = userDao.get(emailOrUsername);
        if (user == null) {
            user = userDao.getByEmail(emailOrUsername);
        }
        if (user == null) {
            return false;
        }

        String otp = EmailUtil.generateOtp(6);
        boolean updated = userDao.updateActiveAndCode(user.getUserName(), user.getActive(), otp);
        if (updated) {
            EmailUtil.sendOtp(user.getEmail(), otp, "Quên mật khẩu / Đặt lại mật khẩu");
            return true;
        }
        return false;
    }

    @Override
    public boolean resetPassword(String emailOrUsername, String otp, String newPassword) {
        User user = userDao.get(emailOrUsername);
        if (user == null) {
            user = userDao.getByEmail(emailOrUsername);
        }
        if (user != null && otp != null && otp.trim().equals(user.getCode())) {
            String hashed = PasswordUtil.hashPassword(newPassword);
            return userDao.updatePasswordByEmail(user.getEmail(), hashed);
        }
        return false;
    }

    @Override
    public boolean updateProfile(int id, String fullname, String phone, String avatar) {
        return userDao.updateProfile(id, fullname, phone, avatar);
    }

    @Override
    public boolean updateEmail(int id, String newEmail) {
        return userDao.updateEmail(id, newEmail);
    }

    @Override
    public boolean sendOtpChangeEmail(int id, String newEmail) {
        String otp = EmailUtil.generateOtp(6);
        // Lưu mã OTP vào cột code của user
        User user = userDao.getByEmail(newEmail);
        if (user != null && user.getId() != id) {
            // Email đã bị người khác sử dụng
            return false;
        }

        boolean sent = EmailUtil.sendOtp(newEmail, otp, "Xác nhận cập nhật Email tài khoản mới");
        return sent;
    }

    @Override
    public boolean verifyChangeEmail(int id, String newEmail, String otp) {
        // Cập nhật email mới
        return userDao.updateEmail(id, newEmail);
    }
}
