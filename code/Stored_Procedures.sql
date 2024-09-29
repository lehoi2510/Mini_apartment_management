-- Stored Procedures hiển thị danh sách căn hộ còn trống
DELIMITER //
CREATE PROCEDURE GetAvailableUnits()
BEGIN
    SELECT u.Unit_ID, u.Number, u.Floor, u.Rent, p.Name AS Property_Name, p.Address
    FROM Unit u
    LEFT JOIN Lease l ON u.Unit_ID = l.Unit_ID
    JOIN Property p ON u.Property_ID = p.Property_ID
    WHERE l.Unit_ID IS NULL;
END //
DELIMITER ;

-- Stored Procedures lấy và hiển thị danh sách cư dân đang cư trú
DELIMITER //
CREATE PROCEDURE GetCurrentResidents()
BEGIN
    SELECT t.Tenant_ID, t.T_Name, t.T_Phone_Number, t.T_Email, t.T_Date_of_Birth, u.Number AS Unit_Number, p.Name AS Property_Name
    FROM Tenant t
    JOIN Lease l ON t.Tenant_ID = l.Tenant_ID
    JOIN Unit u ON l.Unit_ID = u.Unit_ID
    JOIN Property p ON u.Property_ID = p.Property_ID
    WHERE l.End_Date > CURDATE() AND l.Status = 'Active';
END //
DELIMITER ;

-- Stored Procedures thêm mới một tiện ích
DELIMITER //
CREATE PROCEDURE AddAmenity(
    IN p_Property_ID INT,
    IN p_Name VARCHAR(255),
    IN p_Description TEXT
)
BEGIN
    INSERT INTO Amenity (Property_ID, Name, Description)
    VALUES (p_Property_ID, p_Name, p_Description);
END //
DELIMITER ;

-- Stored Procedure thêm mới một hợp đồng thuê
DELIMITER //
CREATE PROCEDURE AddLease(
    IN p_Unit_ID INT,
    IN p_Tenant_ID INT,
    IN p_Start_Date DATE,
    IN p_End_Date DATE,
    IN p_Monthly_Rent DECIMAL(10, 2),
    IN p_Deposit DECIMAL(10, 2),
    IN p_Status VARCHAR(50)
)
BEGIN
    INSERT INTO Lease (Unit_ID, Tenant_ID, Start_Date, End_Date, Monthly_Rent, Deposit, Status)
    VALUES (p_Unit_ID, p_Tenant_ID, p_Start_Date, p_End_Date, p_Monthly_Rent, p_Deposit, p_Status);
END //
DELIMITER ;

-- Stored Procedure thêm mới một yêu cầu bảo trì
DELIMITER //
CREATE PROCEDURE AddMaintenanceRequest(
    IN p_Reported_By INT,
    IN p_Date_Reported DATE,
    IN p_Urgency VARCHAR(50),
    IN p_Description TEXT,
    IN p_Status VARCHAR(50)
)
BEGIN
    INSERT INTO Maintenance_Request (Reported_By, Date_Reported, Urgency, Description, Status)
    VALUES (p_Reported_By, p_Date_Reported, p_Urgency, p_Description, p_Status);
END //
DELIMITER ;
