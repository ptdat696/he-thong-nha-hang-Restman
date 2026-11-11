package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Types;
import java.util.ArrayList;

import model.Reservation6;
import model.Table6;
import model.Customer6;

/** Truy cập bảng tblReservation6 (module Book table online). */
public class Reservation6DAO extends DAO6 {

    /** Khóa dòng bàn để hai khách không đặt trùng cùng lúc. */
    private static final String SQL_LOCK_TABLE =
            "SELECT id FROM tblTable6 WHERE id = ? AND status = 'ACTIVE' FOR UPDATE";

    /** Đếm đơn đặt bàn (chưa hủy) trùng khoảng giờ. Tham số: bàn, ngày, cận dưới, cận trên. */
    private static final String SQL_COUNT_OVERLAP =
            "SELECT COUNT(*) FROM tblReservation6 "
            + "WHERE tableId = ? AND reservationDate = ? AND status <> 'CANCELLED' "
            + "AND reservationTime > ? AND reservationTime < ?";

    private static final String SQL_INSERT =
            "INSERT INTO tblReservation6 (reservationDate, reservationTime, "
            + "customerName, customerPhone, status, tableId, customerId, salesStaffId) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    /** Lấy tất cả đơn đặt bàn của một khách, mới nhất trước. */
    private static final String SQL_BY_CUSTOMER =
            "SELECT r.id, r.reservationDate, r.reservationTime, "
            + "r.customerName, r.customerPhone, r.status, "
            + "t.id AS tableId, t.tableNumber, t.capacity "
            + "FROM tblReservation6 r "
            + "JOIN tblTable6 t ON t.id = r.tableId "
            + "WHERE r.customerId = ? "
            + "ORDER BY r.reservationDate DESC, r.reservationTime DESC";

    /** Lấy tất cả đơn đặt bàn (nhân viên xem), mới nhất trước. */
    private static final String SQL_ALL =
            "SELECT r.id, r.reservationDate, r.reservationTime, "
            + "r.customerName, r.customerPhone, r.status, "
            + "t.id AS tableId, t.tableNumber, t.capacity, "
            + "u.fullName AS custFullName "
            + "FROM tblReservation6 r "
            + "JOIN tblTable6 t ON t.id = r.tableId "
            + "JOIN tblUser6 u ON u.id = r.customerId "
            + "ORDER BY r.reservationDate DESC, r.reservationTime DESC";

    /** Lấy một đơn theo id. */
    private static final String SQL_BY_ID =
            "SELECT r.id, r.reservationDate, r.reservationTime, "
            + "r.customerName, r.customerPhone, r.status, "
            + "t.id AS tableId, t.tableNumber, t.capacity "
            + "FROM tblReservation6 r "
            + "JOIN tblTable6 t ON t.id = r.tableId "
            + "WHERE r.id = ?";

    /** Cập nhật trạng thái đơn và gán nhân viên xác nhận. */
    private static final String SQL_UPDATE_STATUS =
            "UPDATE tblReservation6 SET status = ?, salesStaffId = ? WHERE id = ? AND status = 'PENDING'";

    public Reservation6DAO() {
        super();
    }

    /**
     * Lưu đơn đặt bàn. Trả về false nếu bàn không còn trống (vừa có người đặt)
     * hoặc có lỗi CSDL; khi đó không có gì được ghi.
     */
    public boolean createReservation(Reservation6 reservation) {
        try {
            con.setAutoCommit(false);
            try {
                int tableId = reservation.getTable().getId();
                Time[] window = slotWindow(reservation.getReservationTime());

                try (PreparedStatement lock = con.prepareStatement(SQL_LOCK_TABLE)) {
                    lock.setInt(1, tableId);
                    try (ResultSet rs = lock.executeQuery()) {
                        if (!rs.next()) {
                            con.rollback();
                            return false;
                        }
                    }
                }

                try (PreparedStatement count = con.prepareStatement(SQL_COUNT_OVERLAP)) {
                    count.setInt(1, tableId);
                    count.setDate(2, reservation.getReservationDate());
                    count.setTime(3, window[0]);
                    count.setTime(4, window[1]);
                    try (ResultSet rs = count.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            con.rollback();
                            return false;
                        }
                    }
                }

                try (PreparedStatement ps = con.prepareStatement(SQL_INSERT,
                        PreparedStatement.RETURN_GENERATED_KEYS)) {
                    ps.setDate(1, reservation.getReservationDate());
                    ps.setTime(2, reservation.getReservationTime());
                    ps.setString(3, reservation.getCustomerName());
                    ps.setString(4, reservation.getCustomerPhone());
                    ps.setString(5, reservation.getStatus());
                    ps.setInt(6, tableId);
                    ps.setInt(7, reservation.getCustomer().getId());
                    if (reservation.getSalesStaff() == null) {
                        ps.setNull(8, Types.INTEGER);
                    } else {
                        ps.setInt(8, reservation.getSalesStaff().getId());
                    }
                    if (ps.executeUpdate() != 1) {
                        con.rollback();
                        return false;
                    }
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (keys.next()) {
                            reservation.setId(keys.getInt(1));
                        }
                    }
                }
                con.commit();
                return true;
            } catch (SQLException e) {
                e.printStackTrace();
                con.rollback();
                return false;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh sách tất cả đơn đặt bàn của khách hàng theo customerId,
     * sắp xếp mới nhất trước.
     */
    public ArrayList<Reservation6> getReservationsByCustomer(int customerId) {
        ArrayList<Reservation6> list = new ArrayList<Reservation6>();
        try (PreparedStatement ps = con.prepareStatement(SQL_BY_CUSTOMER)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs, false));
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi lấy lịch đặt bàn: " + e.getMessage(), e);
        }
        return list;
    }

    /**
     * Lấy toàn bộ đơn đặt bàn (nhân viên xem), sắp xếp mới nhất trước.
     */
    public ArrayList<Reservation6> getAllReservations() {
        ArrayList<Reservation6> list = new ArrayList<Reservation6>();
        try (PreparedStatement ps = con.prepareStatement(SQL_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Reservation6 r = mapRow(rs, false);
                // Tên tài khoản khách (fullName từ tblUser6)
                r.setCustomerName(rs.getString("custFullName") != null
                        ? rs.getString("custFullName")
                        : r.getCustomerName());
                // Lưu tên liên hệ vào customerName của reservation để hiển thị
                // (đây là tên nhập khi đặt, lấy lại bên dưới)
                r.setCustomerName(rs.getString("customerName"));
                // custFullName dùng riêng — tạo đối tượng Customer6 dummy để giữ
                Customer6 dummy = new Customer6();
                dummy.setFullName(rs.getString("custFullName"));
                r.setCustomer(dummy);
                list.add(r);
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi lấy danh sách đặt bàn: " + e.getMessage(), e);
        }
        return list;
    }

    /**
     * Lấy một đơn theo id.
     * Trả về null nếu không tồn tại.
     */
    public Reservation6 getById(int id) {
        try (PreparedStatement ps = con.prepareStatement(SQL_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs, false);
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi lấy đơn đặt bàn: " + e.getMessage(), e);
        }
        return null;
    }

    /**
     * Cập nhật trạng thái đơn (CONFIRMED hoặc CANCELLED) và gán nhân viên.
     * Chỉ cập nhật nếu đơn đang ở PENDING.
     * Trả về true nếu cập nhật thành công.
     */
    public boolean updateStatus(int reservationId, String newStatus, int salesStaffId) {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE_STATUS)) {
            ps.setString(1, newStatus);
            ps.setInt(2, salesStaffId);
            ps.setInt(3, reservationId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi cập nhật trạng thái đơn: " + e.getMessage(), e);
        }
    }

    // ---- Helper ----

    private Reservation6 mapRow(ResultSet rs, boolean hasCustName) throws SQLException {
        Reservation6 r = new Reservation6();
        r.setId(rs.getInt("id"));
        r.setReservationDate(rs.getDate("reservationDate"));
        r.setReservationTime(rs.getTime("reservationTime"));
        r.setCustomerName(rs.getString("customerName"));
        r.setCustomerPhone(rs.getString("customerPhone"));
        r.setStatus(rs.getString("status"));

        Table6 table = new Table6();
        table.setId(rs.getInt("tableId"));
        table.setTableNumber(rs.getString("tableNumber"));
        table.setCapacity(rs.getInt("capacity"));
        r.setTable(table);
        return r;
    }
}
