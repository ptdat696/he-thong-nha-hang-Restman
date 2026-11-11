# RestMan6 – Hệ thống quản lí nhà hàng

Cài đặt 2 module theo thiết kế đã phân tích:

1. **Thêm thông tin món ăn** (Nhân viên quản lí)
2. **Đặt bàn trực tuyến** (Khách hàng)

Các chức năng khác (thống kê, combo, nhập kho, bán hàng, tìm kiếm, đặt món...) chỉ là **nút bấm thường**, bấm vào sẽ hiện thông báo "Chức năng này chưa được triển khai". Giao diện vuông, không bo góc.

## Yêu cầu

- JDK 11 trở lên
- Apache Tomcat 9 hoặc 10.1 (trang JSP không dùng kiểu servlet nên chạy được cả hai)
- MySQL 8.x
- Maven 3.8+ (nếu build bằng Maven)

## Cài đặt

### 1. Tạo cơ sở dữ liệu

Chạy toàn bộ file `database/restman6.sql` (MySQL Workbench hoặc `mysql -u root -p < database/restman6.sql`).
File sẽ **xóa và tạo lại** CSDL `restman6` gồm 16 bảng cùng dữ liệu mẫu.

### 2. Cấu hình kết nối

Mặc định: `jdbc:mysql://localhost:3306/restman6`, tài khoản `root`, mật khẩu `root`.
Đổi bằng một trong hai cách:

- Sửa 3 giá trị mặc định ở đầu `src/main/java/dao/DAO6.java`, hoặc
- Đặt biến môi trường `RESTMAN_DB_URL`, `RESTMAN_DB_USER`, `RESTMAN_DB_PASSWORD` trước khi chạy Tomcat.

### 3. Build và chạy

```
mvn clean package
```

Chép `target/RestMan6.war` vào thư mục `webapps` của Tomcat rồi mở `http://localhost:8080/RestMan6/`.

Dùng NetBeans / Eclipse / IntelliJ: mở thư mục này như một dự án Maven, thêm Tomcat làm server rồi Run.
Nếu tạo dự án Dynamic Web Project thủ công: chép `src/main/java` vào `src`, `src/main/webapp` vào `WebContent`, và thêm `mysql-connector-j-8.x.jar` vào `WEB-INF/lib`.

## Tài khoản mẫu (mật khẩu đều là `123456`)

| Tên đăng nhập | Vai trò                | Trang chủ sau đăng nhập |
|---------------|------------------------|-------------------------|
| `manager`     | Nhân viên quản lí      | `gdMainManager6.jsp`    |
| `warehouse`   | Nhân viên kho          | `gdMainWarehouse6.jsp`  |
| `sales`       | Nhân viên bán hàng     | `gdMainSales6.jsp`      |
| `customer1`   | Khách hàng             | `gdMainCustomer6.jsp`   |
| `customer2`   | Khách hàng             | `gdMainCustomer6.jsp`   |

Mật khẩu lưu dạng SHA-256 trong `tblUser6`.

## Luồng thử nghiệm

**Module 1** – đăng nhập `manager` → *Quản lí món ăn* → *Thêm món ăn* → nhập tên, giá, mô tả, trạng thái → *Thêm* → thông báo → *OK* về danh sách (món mới ở cuối).

**Module 2** – đăng nhập `customer1` → *Đặt bàn* → chọn ngày giờ (10:00–21:00) → *Tìm bàn* → *Chọn bàn* → kiểm tra họ tên, điện thoại, số người → *Xác nhận*. Đơn được lưu với trạng thái `PENDING`, chờ nhân viên bán hàng xác nhận.

Dữ liệu mẫu có sẵn 2 đơn đặt vào ngày mai (T03 lúc 19:00, T06 lúc 19:30) và bàn T08 đang bảo trì, để thử việc loại bàn không trống. Mỗi lượt giữ bàn **120 phút**: bàn đã có đơn lúc 19:00 thì không nhận đặt trong khoảng từ 17:01 đến 20:59.

## Cấu trúc (khớp với thiết kế)

```
database/restman6.sql             CSDL 16 bảng + dữ liệu mẫu
src/main/java/model/              User6, Employee6, Manager6, WarehouseStaff6, SalesStaff6,
                                  Customer6, Dish6, Table6, Reservation6
src/main/java/dao/                DAO6 (lớp cha), User6DAO, Dish6DAO, Table6DAO, Reservation6DAO
src/main/webapp/view/user/        gdLogin6, doLogin6, doLogout6
src/main/webapp/view/manager/     gdMainManager6, gdDishManagement6, gdAddDish6, doAddDish6
src/main/webapp/view/customer/    gdMainCustomer6, gdFindTable6, gdTableList6,
                                  gdConfirmReservation6, doConfirmReservation6
src/main/webapp/view/warehouse/   gdMainWarehouse6   (trang chủ, nút thường)
src/main/webapp/view/sales/       gdMainSales6       (trang chủ, nút thường)
src/main/webapp/view/common/      head.jspf, foot.jspf (khung trang dùng chung)
src/main/webapp/assets/style.css  giao diện vuông
```

`gd*` là trang giao diện, `do*` là trang xử lí. Sau khi xử lí, trang `do*` chuyển hướng (POST → redirect → GET) nên tải lại trang không thêm món hoặc đặt bàn lần thứ hai.

## Lưu ý

- Khi hai khách cùng chọn một bàn, `Reservation6DAO.createReservation()` khóa dòng bàn và kiểm tra lại trong một giao dịch; người đến sau nhận thông báo "bàn vừa có người đặt".
- Chỉ cài các lớp thực thể mà 2 module cần; các lớp còn lại (Combo, Ingredient, Order, Invoice...) có trong CSDL nhưng chưa có lớp Java.
- Nếu không kết nối được MySQL, trang báo lỗi 500 với nội dung "Không kết nối được CSDL restman6".
