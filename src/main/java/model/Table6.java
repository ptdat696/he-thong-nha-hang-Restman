package model;

import java.util.ArrayList;

/** Bàn ăn. */
public class Table6 {
    private int id;
    private String tableNumber;
    private int capacity;
    private String status;       // ACTIVE / MAINTENANCE
    private ArrayList<Reservation6> reservations = new ArrayList<Reservation6>();

    public Table6() {
    }

    public Table6(int id, String tableNumber, int capacity, String status) {
        this.id = id;
        this.tableNumber = tableNumber;
        this.capacity = capacity;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTableNumber() { return tableNumber; }
    public void setTableNumber(String tableNumber) { this.tableNumber = tableNumber; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public ArrayList<Reservation6> getReservations() { return reservations; }
    public void setReservations(ArrayList<Reservation6> reservations) { this.reservations = reservations; }
}
