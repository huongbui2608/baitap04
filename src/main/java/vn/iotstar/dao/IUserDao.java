package vn.iotstar.dao;

import vn.iotstar.model.User;

public interface IUserDao {
    User get(String username);
    User getByEmail(String email);
    boolean insert(User user);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
    boolean checkExistPhone(String phone);
    boolean updatePassword(int id, String newHashedPassword);
    boolean updatePasswordByEmail(String email, String newHashedPassword);
    boolean updateActiveAndCode(String username, int active, String code);
    boolean activateUser(String emailOrUsername);
    User getByCode(String code);
    boolean updateProfile(int id, String fullname, String phone, String avatar);
    boolean updateEmail(int id, String newEmail);
}
