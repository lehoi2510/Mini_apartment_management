-- Bảng Property (Chung cư)
CREATE TABLE Property (
    Property_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Manager_ID INT
);

-- Bảng Unit (Căn hộ)
CREATE TABLE Unit (
    Unit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Property_ID INT,
    Number VARCHAR(50) NOT NULL,
    Floor DECIMAL(10, 2) NOT NULL,
	Rent INT NOT NULL,
    FOREIGN KEY (Property_ID) REFERENCES Property(Property_ID)
);

-- Bảng Tenant (Người thuê)
CREATE TABLE Tenant (
    Tenant_ID INT AUTO_INCREMENT PRIMARY KEY,
    T_Name VARCHAR(255) NOT NULL,
    T_Phone_Number VARCHAR(50) NOT NULL,
    T_Email VARCHAR(100),
    T_Date_of_Birth DATE NOT NULL
);

-- Bảng Lease (Hợp đồng thuê)
CREATE TABLE Lease (
    Lease_ID INT AUTO_INCREMENT PRIMARY KEY,
    Unit_ID INT,
    Tenant_ID INT,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Monthly_Rent DECIMAL(10, 2) NOT NULL,
    Deposit DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(50),
    FOREIGN KEY (Unit_ID) REFERENCES Unit(Unit_ID),
    FOREIGN KEY (Tenant_ID) REFERENCES Tenant(Tenant_ID)
);

-- Bảng Payment (Thanh toán)
CREATE TABLE Payment (
    Payment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Lease_ID INT,
    Invoice_Date DATE NOT NULL,
    Amount DECIMAL(10, 2),
    Payment_Type VARCHAR(50),
    Status VARCHAR(50),
    Payment_Date DATE,
    FOREIGN KEY (Lease_ID) REFERENCES Lease(Lease_ID)
);

-- Bảng Maintenance_Request (Yêu cầu bảo trì)
CREATE TABLE Maintenance_Request (
    Request_ID INT AUTO_INCREMENT PRIMARY KEY,
    Reported_By INT, -- ID của người báo cáo yêu cầu
    Date_Reported DATE NOT NULL,
    Urgency VARCHAR(50) NOT NULL,
    Description TEXT,
    Status VARCHAR(50),
    FOREIGN KEY (Reported_By) REFERENCES Tenant(Tenant_ID) -- Hoặc có thể là một bảng khác
);

-- Bảng Employee (Nhân viên)
CREATE TABLE Employee (
    Employee_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Role VARCHAR(100) NOT NULL,
    Contact_Number VARCHAR(50) NOT NULL
);

-- Bảng Maintenance_Job (Công việc bảo trì)
CREATE TABLE Maintenance_Job (
    Job_ID INT AUTO_INCREMENT PRIMARY KEY,
    Request_ID INT,
    Assigned_To INT, -- Nhân viên thực hiện
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Cost DECIMAL(10, 2),
    FOREIGN KEY (Request_ID) REFERENCES Maintenance_Request(Request_ID),
    FOREIGN KEY (Assigned_To) REFERENCES Employee(Employee_ID)
);

-- Bảng Amenity (Tiện ích)
CREATE TABLE Amenity (
    Amenity_ID INT AUTO_INCREMENT PRIMARY KEY,
    Property_ID INT,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    FOREIGN KEY (Property_ID) REFERENCES Property(Property_ID)
);

-- Bảng Booking (Đặt chỗ tiện ích)
CREATE TABLE Booking (
    Tenant_ID INT,
    Amenity_ID INT,
    Start_Time DATE NOT NULL,
    End_Time DATE NOT NULL,
    Cost DECIMAL(10,2),
	PRIMARY KEY (Tenant_ID, Amenity_ID),
    FOREIGN KEY (Tenant_ID) REFERENCES Tenant(Tenant_ID),
    FOREIGN KEY (Amenity_ID) REFERENCES Amenity(Amenity_ID)
);

-- Bảng Contract (Hợp đồng dịch vụ)
CREATE TABLE Contract (
    Vendor_ID INT,
    Property_ID INT,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Cost DECIMAL(10, 2),
    FOREIGN KEY (Vendor_ID) REFERENCES Vendor(Vendor_ID),
    FOREIGN KEY (Property_ID) REFERENCES Property(Property_ID)
);

-- Bảng Vendor (Nhà cung cấp)
CREATE TABLE Vendor (
    Vendor_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Service_Type VARCHAR(100) NOT NULL,
    Contact_Info VARCHAR(255) NOT NULL
);
-- Ràng buộc
ALTER TABLE Unit
ADD CONSTRAINT chk_rent CHECK (Rent > 0);

ALTER TABLE Lease
ADD CONSTRAINT chk_monthly_rent CHECK (Monthly_Rent > 0),
ADD CONSTRAINT chk_dates CHECK (Start_Date < End_Date);

ALTER TABLE Payment
ADD CONSTRAINT chk_payment_amount CHECK (Amount >= 0);

ALTER TABLE Maintenance_Job
ADD CONSTRAINT chk_maintenance_cost CHECK (Cost >= 0);

ALTER TABLE Contract
ADD CONSTRAINT chk_contract_cost CHECK (Cost >= 0);

ALTER TABLE Tenant
ADD CONSTRAINT uq_phone_number UNIQUE (T_Phone_Number),
ADD CONSTRAINT uq_email UNIQUE (T_Email);

ALTER TABLE Payment
MODIFY COLUMN Status VARCHAR(50) DEFAULT 'Pending';

ALTER TABLE Maintenance_Request
MODIFY COLUMN Status VARCHAR(50) DEFAULT 'Open';

ALTER TABLE Payment
MODIFY COLUMN Amount DECIMAL(10, 2) DEFAULT 0;

ALTER TABLE Tenant
	ADD CHECK (Tenant_Email LIKE '%@gmail.com');
