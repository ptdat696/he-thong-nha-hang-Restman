package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalTime;

/**
 * Lớp cha của mọi DAO: giữ kết nối CSDL (thuộc tính con) dùng chung.
 *
 * Cấu hình kết nối: sửa 3 giá trị mặc định bên dưới, hoặc đặt biến môi trường
 * RESTMAN_DB_URL, RESTMAN_DB_USER, RESTMAN_DB_PASSWORD.
 */
public abstract class DAO6 {

    /** Mỗi lượt đặt bàn giữ bàn trong 120 phút. */
    protected static final int SLOT_MINUTES = 120;

    private static final String DB_URL = env("RESTMAN_DB_URL",
            "jdbc:mysql://localhost:3306/restman6"
            + "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh");
    private static final String DB_USER = env("RESTMAN_DB_USER", "root");
    private static final String DB_PASSWORD = env("RESTMAN_DB_PASSWORD", "root");

    protected Connection con;

    public DAO6() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("Thiếu thư viện MySQL Connector/J trong WEB-INF/lib", e);
        } catch (SQLException e) {
            throw new IllegalStateException("Không kết nối được CSDL restman6: " + e.getMessage(), e);
        }
    }

    /** Đóng kết nối; mỗi trang gọi sau khi dùng xong DAO. */
    public void close() {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Khoảng giờ bị coi là trùng với một lượt đặt bàn lúc {@code t}:
     * (t - 120 phút, t + 120 phút), hai đầu mút không tính.
     * Phần tử 0 là cận dưới, phần tử 1 là cận trên (không vượt qua nửa đêm).
     */
    protected static Time[] slotWindow(Time t) {
        LocalTime lt = t.toLocalTime();
        LocalTime lower = lt.minusMinutes(SLOT_MINUTES);
        LocalTime upper = lt.plusMinutes(SLOT_MINUTES);
        if (lower.isAfter(lt)) {
            lower = LocalTime.MIN;
        }
        if (upper.isBefore(lt)) {
            upper = LocalTime.MAX;
        }
        return new Time[] { Time.valueOf(lower), Time.valueOf(upper) };
    }

    private static String env(String name, String defaultValue) {
        String v = System.getenv(name);
        return (v == null || v.isEmpty()) ? defaultValue : v;
    }
}
