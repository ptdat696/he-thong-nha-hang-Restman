package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.Dish6;
import model.Manager6;

/** Truy cập bảng tblDish6 (module Add food information). */
public class Dish6DAO extends DAO6 {

    private static final String SQL_ALL_DISHES =
            "SELECT id, dishName, price, description, status, managerId "
            + "FROM tblDish6 ORDER BY id";

    private static final String SQL_ADD_DISH =
            "INSERT INTO tblDish6 (dishName, price, description, status, managerId) "
            + "VALUES (?, ?, ?, ?, ?)";

    public Dish6DAO() {
        super();
    }

    /** Lấy toàn bộ món ăn để hiển thị ở trang quản lí món ăn. */
    public ArrayList<Dish6> getAllDishes() {
        ArrayList<Dish6> list = new ArrayList<Dish6>();
        try (PreparedStatement ps = con.prepareStatement(SQL_ALL_DISHES);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Dish6 dish = new Dish6();
                dish.setId(rs.getInt("id"));
                dish.setDishName(rs.getString("dishName"));
                dish.setPrice(rs.getFloat("price"));
                dish.setDescription(rs.getString("description"));
                dish.setStatus(rs.getBoolean("status"));
                Manager6 manager = new Manager6();   // chỉ đóng gói id, bỏ qua thuộc tính con
                manager.setId(rs.getInt("managerId"));
                dish.setManager(manager);
                list.add(dish);
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi đọc danh sách món ăn: " + e.getMessage(), e);
        }
        return list;
    }

    /** Thêm một món ăn mới. Trả về true nếu lưu thành công. */
    public boolean addDish(Dish6 dish) {
        try (PreparedStatement ps = con.prepareStatement(SQL_ADD_DISH,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, dish.getDishName());
            ps.setFloat(2, dish.getPrice());
            ps.setString(3, dish.getDescription());
            ps.setBoolean(4, dish.isStatus());
            ps.setInt(5, dish.getManager().getId());
            if (ps.executeUpdate() != 1) {
                return false;
            }
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    dish.setId(keys.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
