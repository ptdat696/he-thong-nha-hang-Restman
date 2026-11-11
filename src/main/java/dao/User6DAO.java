package dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Customer6;
import model.Employee6;
import model.Manager6;
import model.SalesStaff6;
import model.User6;
import model.WarehouseStaff6;

/** Đăng nhập: gói user của hệ thống. */
public class User6DAO extends DAO6 {

    private static final String SQL_LOGIN =
            "SELECT u.id, u.username, u.email, u.phone, u.fullName, u.address, "
            + "e.position, e.dateOfBirth, c.userId AS customerUserId "
            + "FROM tblUser6 u "
            + "LEFT JOIN tblEmployee6 e ON e.userId = u.id "
            + "LEFT JOIN tblCustomer6 c ON c.userId = u.id "
            + "WHERE u.username = ? AND u.password = ?";

    public User6DAO() {
        super();
    }

    /**
     * Kiểm tra đăng nhập. Trả về Manager6, WarehouseStaff6, SalesStaff6 hoặc
     * Customer6 tùy vai trò; trả về null nếu sai tên đăng nhập hoặc mật khẩu.
     */
    public User6 checkLogin(String username, String password) {
        try (PreparedStatement ps = con.prepareStatement(SQL_LOGIN)) {
            ps.setString(1, username);
            ps.setString(2, sha256(password));
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                String position = rs.getString("position");
                boolean isCustomer = rs.getObject("customerUserId") != null;

                User6 user;
                if ("MANAGER".equals(position)) {
                    user = new Manager6();
                } else if ("WAREHOUSE".equals(position)) {
                    user = new WarehouseStaff6();
                } else if ("SALES".equals(position)) {
                    user = new SalesStaff6();
                } else if (isCustomer) {
                    user = new Customer6();
                } else {
                    return null;
                }
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setFullName(rs.getString("fullName"));
                user.setAddress(rs.getString("address"));
                if (user instanceof Employee6) {
                    ((Employee6) user).setPosition(position);
                    ((Employee6) user).setDateOfBirth(rs.getDate("dateOfBirth"));
                }
                return user;
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi đăng nhập: " + e.getMessage(), e);
        }
    }

    /** SHA-256 dạng hex chữ thường, khớp với cột password trong CSDL mẫu. */
    public static String sha256(String text) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(text.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(bytes.length * 2);
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        }
    }
}
