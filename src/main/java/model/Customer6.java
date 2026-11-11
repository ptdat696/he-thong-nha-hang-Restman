package model;

import java.util.ArrayList;

/** Khách hàng. */
public class Customer6 extends User6 {
    private ArrayList<Reservation6> reservations = new ArrayList<Reservation6>();

    public Customer6() {
    }

    public ArrayList<Reservation6> getReservations() { return reservations; }
    public void setReservations(ArrayList<Reservation6> reservations) { this.reservations = reservations; }
}
