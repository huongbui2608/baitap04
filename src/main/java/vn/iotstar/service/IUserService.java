package vn.iotstar.service;

import vn.iotstar.model.User;

public interface IUserService {
    User login(String username, String password);
    User get(String username);
    User getByEmail(String email);
    boolean insert(User user);
    boolean register(String username, String password, String email, String fullname, String phone, String otp);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
    boolean checkExistPhone(String phone);
    boolean verifyOtp(String emailOrUsername, String otp);
    boolean sendForgotPasswordOtp(String emailOrUsername);
    boolean resetPassword(String emailOrUsername, String otp, String newPassword);
    boolean updateProfile(int id, String fullname, String phone, String avatar);
    boolean updateEmail(int id, String newEmail);
    boolean sendOtpChangeEmail(int id, String newEmail);
    boolean verifyChangeEmail(int id, String newEmail, String otp);
}
