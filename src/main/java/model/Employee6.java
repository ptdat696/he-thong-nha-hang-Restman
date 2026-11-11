package model;

import java.sql.Date;

/** Nhân viên. Vai trò (quản lí, kho, bán hàng) nằm ở thuộc tính position. */
public class Employee6 extends User6 {
    private Date dateOfBirth;
    private String position;

    public Employee6() {
    }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
}
