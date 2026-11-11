package dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;

import model.Reservation6;
import model.Table6;

/** Truy cập bảng tblTable6 (module Book table online). */
public class Table6DAO extends DAO6 {

    /**
     * Bàn trống = bàn đang dùng (ACTIVE) và không có đơn đặt bàn (chưa hủy)
     * nào cùng ngày mà giờ nằm trong khoảng (giờ chọn - 120 phút, giờ chọn + 120 phút).
     * Tham số: 1 = ngày, 2 = cận dưới, 3 = cận trên.
     */
    private static final String SQL_AVAILABLE_TABLES =
            "SELECT t.id, t.tableNumber, t.capacity, t.status "
            + "FROM tblTable6 t "
            + "WHERE t.status = 'ACTIVE' "
            + "AND NOT EXISTS ("
            + "SELECT 1 FROM tblReservation6 r "
            + "WHERE r.tableId = t.id "
            + "AND r.reservationDate = ? "
            + "AND r.status <> 'CANCELLED' "
            + "AND r.reservationTime > ? "
            + "AND r.reservationTime < ?) "
            + "ORDER BY t.capacity, t.tableNumber";

    /**
     * Tất cả bàn kèm các đơn đặt bàn (chưa hủy) từ ngày chỉ định trở đi.
     * Bàn chưa có đơn nào vẫn xuất hiện (LEFT JOIN). Tham số: 1 = ngày bắt đầu.
     */
    private static final String SQL_ALL_TABLES =
            "SELECT t.id, t.tableNumber, t.capacity, t.status, "
            + "r.id AS reservationId, r.reservationDate, r.reservationTime "
            + "FROM tblTable6 t "
            + "LEFT JOIN tblReservation6 r ON r.tableId = t.id "
            + "AND r.status <> 'CANCELLED' AND r.reservationDate >= ? "
            + "ORDER BY t.tableNumber, r.reservationDate, r.reservationTime";

    public Table6DAO() {
        super();
    }

    /** Danh sách mọi bàn (cả bàn trống lẫn bàn đã có lịch đặt từ ngày fromDate trở đi). */
    public ArrayList<Table6> getAllTables(Date fromDate) {
        ArrayList<Table6> list = new ArrayList<Table6>();
        try (PreparedStatement ps = con.prepareStatement(SQL_ALL_TABLES)) {
            ps.setDate(1, fromDate);
            try (ResultSet rs = ps.executeQuery()) {
                Table6 current = null;
                while (rs.next()) {
                    int id = rs.getInt("id");
                    if (current == null || current.getId() != id) {
                        current = new Table6();
                        current.setId(id);
                        current.setTableNumber(rs.getString("tableNumber"));
                        current.setCapacity(rs.getInt("capacity"));
                        current.setStatus(rs.getString("status"));
                        list.add(current);
                    }
                    if (rs.getObject("reservationId") != null) {
                        Reservation6 r = new Reservation6();
                        r.setId(rs.getInt("reservationId"));
                        r.setReservationDate(rs.getDate("reservationDate"));
                        r.setReservationTime(rs.getTime("reservationTime"));
                        current.getReservations().add(r);
                    }
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi lấy danh sách bàn: " + e.getMessage(), e);
        }
        return list;
    }

    /** Tìm danh sách bàn còn trống vào ngày, giờ khách chọn. */
    public ArrayList<Table6> getAvailableTables(Date date, Time time) {
        ArrayList<Table6> list = new ArrayList<Table6>();
        Time[] window = slotWindow(time);
        try (PreparedStatement ps = con.prepareStatement(SQL_AVAILABLE_TABLES)) {
            ps.setDate(1, date);
            ps.setTime(2, window[0]);
            ps.setTime(3, window[1]);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Table6 table = new Table6();
                    table.setId(rs.getInt("id"));
                    table.setTableNumber(rs.getString("tableNumber"));
                    table.setCapacity(rs.getInt("capacity"));
                    table.setStatus(rs.getString("status"));
                    list.add(table);
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi tìm bàn trống: " + e.getMessage(), e);
        }
        return list;
    }
}
