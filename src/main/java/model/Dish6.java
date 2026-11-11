package model;

/** Món ăn. */
public class Dish6 {
    private int id;
    private String dishName;
    private float price;
    private String description;
    private boolean status;      // true: đang bán, false: ngừng bán
    private Manager6 manager;    // nhân viên quản lí đã thêm món

    public Dish6() {
    }

    public Dish6(int id, String dishName, float price, String description,
                 boolean status, Manager6 manager) {
        this.id = id;
        this.dishName = dishName;
        this.price = price;
        this.description = description;
        this.status = status;
        this.manager = manager;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getDishName() { return dishName; }
    public void setDishName(String dishName) { this.dishName = dishName; }
    public float getPrice() { return price; }
    public void setPrice(float price) { this.price = price; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
    public Manager6 getManager() { return manager; }
    public void setManager(Manager6 manager) { this.manager = manager; }
}
