package model;

import java.sql.Date;
import java.sql.Time;

/** Đơn đặt bàn. */
public class Reservation6 {
    public static final String PENDING = "PENDING"; // chờ nhân viên xác nhận
    public static final String CONFIRMED = "CONFIRMED"; // đã xác nhận
    public static final String CANCELLED = "CANCELLED"; // đã hủy

    private int id;
    private Date reservationDate;
    private Time reservationTime;
    private int numberOfGuests;
    private String customerName;
    private String customerPhone;
    private String status = PENDING;
    private Table6 table;
    private Customer6 customer;
    private SalesStaff6 salesStaff; // null cho đến khi nhân viên xác nhận

    public Reservation6() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getReservationDate() {
        return reservationDate;
    }

    public void setReservationDate(Date reservationDate) {
        this.reservationDate = reservationDate;
    }

    public Time getReservationTime() {
        return reservationTime;
    }

    public void setReservationTime(Time reservationTime) {
        this.reservationTime = reservationTime;
    }

    public int getNumberOfGuests() {
        return numberOfGuests;
    }

    public void setNumberOfGuests(int numberOfGuests) {
        this.numberOfGuests = numberOfGuests;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Table6 getTable() {
        return table;
    }

    public void setTable(Table6 table) {
        this.table = table;
    }

    public Customer6 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer6 customer) {
        this.customer = customer;
    }

    public SalesStaff6 getSalesStaff() {
        return salesStaff;
    }

    public void setSalesStaff(SalesStaff6 salesStaff) {
        this.salesStaff = salesStaff;
    }
}
