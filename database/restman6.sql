-- ============================================================
--  RestMan6 - Cơ sở dữ liệu (MySQL 8.x)
--  16 bảng theo sơ đồ CSDL đã thiết kế (tên bảng: tbl + lớp + 6)
--  Chạy toàn bộ file này bằng MySQL Workbench / mysql client.
--  Mật khẩu của các tài khoản mẫu là: 123456 (lưu dạng SHA-256)
-- ============================================================

DROP DATABASE IF EXISTS restman6;
CREATE DATABASE restman6 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restman6;

-- ---------- Người dùng ----------
-- FullName và Address đã gộp vào tblUser6 (không còn bảng riêng)
CREATE TABLE tblUser6 (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  username  VARCHAR(255) NOT NULL UNIQUE,
  password  VARCHAR(255) NOT NULL,
  email     VARCHAR(255),
  phone     VARCHAR(255),
  fullName  VARCHAR(255),
  address   VARCHAR(255)
) ENGINE=InnoDB;

-- Vai trò của nhân viên nằm ở cột position: MANAGER / WAREHOUSE / SALES
CREATE TABLE tblEmployee6 (
  userId      INT PRIMARY KEY,
  dateOfBirth DATE,
  position    VARCHAR(255) NOT NULL,
  FOREIGN KEY (userId) REFERENCES tblUser6(id)
) ENGINE=InnoDB;

CREATE TABLE tblCustomer6 (
  userId INT PRIMARY KEY,
  FOREIGN KEY (userId) REFERENCES tblUser6(id)
) ENGINE=InnoDB;

CREATE TABLE tblSupplier6 (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  supplierName  VARCHAR(255) NOT NULL,
  phone         VARCHAR(255),
  suppliedGoods VARCHAR(255),
  address       VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE tblMembershipCard6 (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  issueDate    DATE,
  cardLevel    VARCHAR(255),
  customerId   INT NOT NULL UNIQUE,
  salesStaffId INT NOT NULL,
  FOREIGN KEY (customerId)   REFERENCES tblCustomer6(userId),
  FOREIGN KEY (salesStaffId) REFERENCES tblEmployee6(userId)
) ENGINE=InnoDB;

-- ---------- Món ăn, combo ----------
CREATE TABLE tblDish6 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  dishName    VARCHAR(255) NOT NULL,
  price       FLOAT NOT NULL,
  description VARCHAR(255),
  status      TINYINT(1) NOT NULL DEFAULT 1,
  managerId   INT NOT NULL,
  FOREIGN KEY (managerId) REFERENCES tblEmployee6(userId)
) ENGINE=InnoDB;

CREATE TABLE tblCombo6 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  comboName   VARCHAR(255) NOT NULL,
  price       FLOAT NOT NULL,
  description VARCHAR(255),
  status      TINYINT(1) NOT NULL DEFAULT 1,
  managerId   INT NOT NULL,
  FOREIGN KEY (managerId) REFERENCES tblEmployee6(userId)
) ENGINE=InnoDB;

CREATE TABLE tblComboDetail6 (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  quantity INT NOT NULL,
  comboId  INT NOT NULL,
  dishId   INT NOT NULL,
  FOREIGN KEY (comboId) REFERENCES tblCombo6(id),
  FOREIGN KEY (dishId)  REFERENCES tblDish6(id)
) ENGINE=InnoDB;

-- ---------- Nguyên liệu, nhập hàng ----------
CREATE TABLE tblIngredient6 (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  ingredientName VARCHAR(255) NOT NULL,
  unit           VARCHAR(255),
  stockQuantity  FLOAT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE tblImportReceipt6 (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  importDate       DATE,
  importTime       TIME,
  supplierId       INT NOT NULL,
  warehouseStaffId INT NOT NULL,
  FOREIGN KEY (supplierId)       REFERENCES tblSupplier6(id),
  FOREIGN KEY (warehouseStaffId) REFERENCES tblEmployee6(userId)
) ENGINE=InnoDB;

CREATE TABLE tblImportReceiptDetail6 (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  quantity        FLOAT NOT NULL,
  unitPrice       FLOAT NOT NULL,
  importReceiptId INT NOT NULL,
  ingredientId    INT NOT NULL,
  FOREIGN KEY (importReceiptId) REFERENCES tblImportReceipt6(id),
  FOREIGN KEY (ingredientId)    REFERENCES tblIngredient6(id)
) ENGINE=InnoDB;

-- ---------- Bàn, đặt bàn ----------
-- status của bàn: ACTIVE (đang dùng) / MAINTENANCE (tạm ngưng)
CREATE TABLE tblTable6 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  tableNumber VARCHAR(255) NOT NULL UNIQUE,
  capacity    INT NOT NULL,
  status      VARCHAR(255) NOT NULL DEFAULT 'ACTIVE'
) ENGINE=InnoDB;

-- status của đơn đặt bàn: PENDING (chờ xác nhận) / CONFIRMED / CANCELLED
-- salesStaffId để trống khi khách đặt trực tuyến, chỉ gán khi nhân viên xác nhận
CREATE TABLE tblReservation6 (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  reservationDate DATE NOT NULL,
  reservationTime TIME NOT NULL,
  numberOfGuests  INT NOT NULL,
  customerName    VARCHAR(255) NOT NULL,
  customerPhone   VARCHAR(255) NOT NULL,
  status          VARCHAR(255) NOT NULL DEFAULT 'PENDING',
  tableId         INT NOT NULL,
  customerId      INT NOT NULL,
  salesStaffId    INT NULL,
  FOREIGN KEY (tableId)      REFERENCES tblTable6(id),
  FOREIGN KEY (customerId)   REFERENCES tblCustomer6(userId),
  FOREIGN KEY (salesStaffId) REFERENCES tblEmployee6(userId)
) ENGINE=InnoDB;

-- ---------- Gọi món, hóa đơn ----------
CREATE TABLE tblOrder6 (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  orderDate    DATE,
  orderTime    TIME,
  orderType    VARCHAR(255),
  status       VARCHAR(255),
  tableId      INT NULL,
  customerId   INT NULL,
  salesStaffId INT NULL,
  FOREIGN KEY (tableId)      REFERENCES tblTable6(id),
  FOREIGN KEY (customerId)   REFERENCES tblCustomer6(userId),
  FOREIGN KEY (salesStaffId) REFERENCES tblEmployee6(userId)
) ENGINE=InnoDB;

CREATE TABLE tblOrderDetail6 (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  quantity  INT NOT NULL,
  unitPrice FLOAT NOT NULL,
  orderId   INT NOT NULL,
  dishId    INT NULL,
  comboId   INT NULL,
  FOREIGN KEY (orderId) REFERENCES tblOrder6(id),
  FOREIGN KEY (dishId)  REFERENCES tblDish6(id),
  FOREIGN KEY (comboId) REFERENCES tblCombo6(id)
) ENGINE=InnoDB;

CREATE TABLE tblInvoice6 (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  issueDate     DATE,
  paymentMethod VARCHAR(255),
  paymentStatus VARCHAR(255),
  orderId       INT NOT NULL UNIQUE,
  salesStaffId  INT NOT NULL,
  FOREIGN KEY (orderId)      REFERENCES tblOrder6(id),
  FOREIGN KEY (salesStaffId) REFERENCES tblEmployee6(userId)
) ENGINE=InnoDB;

-- ============================================================
--  DỮ LIỆU MẪU
-- ============================================================

-- Mật khẩu 123456 (SHA-256)
INSERT INTO tblUser6 (id, username, password, email, phone, fullName, address) VALUES
(1, 'manager',   '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'manager@restman.vn',   '0901000001', 'Nguyễn Văn Quản', '12 Nguyễn Trãi, Thanh Xuân, Hà Nội'),
(2, 'warehouse', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'warehouse@restman.vn', '0901000002', 'Trần Văn Kho',    '25 Lê Văn Lương, Thanh Xuân, Hà Nội'),
(3, 'sales',     '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'sales@restman.vn',     '0901000003', 'Lê Thị Bán',       '8 Trần Duy Hưng, Cầu Giấy, Hà Nội'),
(4, 'customer1', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'khach1@gmail.com',     '0912345678', 'Phạm Minh Khách',  '40 Hoàng Quốc Việt, Cầu Giấy, Hà Nội'),
(5, 'customer2', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'khach2@gmail.com',     '0987654321', 'Hoàng Thu Hà',     '5 Phạm Hùng, Nam Từ Liêm, Hà Nội');

INSERT INTO tblEmployee6 (userId, dateOfBirth, position) VALUES
(1, '1985-03-12', 'MANAGER'),
(2, '1990-07-21', 'WAREHOUSE'),
(3, '1995-11-02', 'SALES');

INSERT INTO tblCustomer6 (userId) VALUES (4), (5);

INSERT INTO tblTable6 (id, tableNumber, capacity, status) VALUES
(1, 'T01', 2,  'ACTIVE'),
(2, 'T02', 2,  'ACTIVE'),
(3, 'T03', 4,  'ACTIVE'),
(4, 'T04', 4,  'ACTIVE'),
(5, 'T05', 4,  'ACTIVE'),
(6, 'T06', 6,  'ACTIVE'),
(7, 'T07', 6,  'ACTIVE'),
(8, 'T08', 10, 'MAINTENANCE');

INSERT INTO tblDish6 (dishName, price, description, status, managerId) VALUES
('Phở bò tái',          55000, 'Phở bò tái nạm, nước dùng hầm xương 12 giờ', 1, 1),
('Bún chả Hà Nội',      50000, 'Chả nướng than hoa, bún tươi, nước chấm chua ngọt', 1, 1),
('Gỏi cuốn tôm thịt',   40000, 'Cuốn 2 cái, kèm tương đậu phộng', 1, 1),
('Cơm tấm sườn bì chả', 60000, 'Sườn nướng, bì, chả trứng, nước mắm pha', 1, 1),
('Cà phê sữa đá',       25000, 'Cà phê phin truyền thống', 1, 1),
('Chè khúc bạch',       30000, 'Món tráng miệng, tạm ngưng bán', 0, 1);

INSERT INTO tblSupplier6 (supplierName, phone, suppliedGoods, address) VALUES
('Công ty Thực phẩm Sạch Hà Nội', '0243111222', 'Rau củ, thịt tươi', 'KCN Thăng Long, Đông Anh, Hà Nội');

INSERT INTO tblIngredient6 (ingredientName, unit, stockQuantity) VALUES
('Thịt bò', 'kg', 20),
('Gạo tám', 'kg', 50);

-- Hai đơn đặt bàn vào ngày mai để thử chức năng tìm bàn trống
INSERT INTO tblReservation6 (reservationDate, reservationTime, numberOfGuests, customerName, customerPhone, status, tableId, customerId, salesStaffId) VALUES
(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '19:00:00', 4, 'Phạm Minh Khách', '0912345678', 'CONFIRMED', 3, 4, 3),
(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '19:30:00', 6, 'Hoàng Thu Hà',     '0987654321', 'PENDING',   6, 5, NULL);
