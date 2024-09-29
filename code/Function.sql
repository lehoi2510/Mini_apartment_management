-- Function tính số lượng căn hộ được thuê trong năm
DELIMITER //
CREATE FUNCTION GetUnitsRentedInYear(p_Year INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE unit_count INT;
    
    SELECT COUNT(DISTINCT Unit_ID)
    INTO unit_count
    FROM Lease
    WHERE YEAR(Start_Date) = p_Year;
    
    RETURN unit_count;
END //
DELIMITER ;

-- Function tính tổng số hợp đồng thuê còn hiệu lực
DELIMITER //
CREATE FUNCTION GetActiveLeases()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE active_lease_count INT;
    
    SELECT COUNT(*)
    INTO active_lease_count
    FROM Lease
    WHERE End_Date >= CURDATE() AND Status = 'Active';
    
    RETURN active_lease_count;
END //
DELIMITER ;

-- Function tính số lần bảo trì của một căn hộ
DELIMITER //
CREATE FUNCTION GetMaintenanceCountForUnit(p_Unit_ID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE maintenance_count INT;
    
    SELECT COUNT(*)
    INTO maintenance_count
    FROM Maintenance_Request r
    JOIN Lease l ON r.Reported_By = l.Tenant_ID
    WHERE l.Unit_ID = p_Unit_ID;
    
    RETURN maintenance_count;
END //
DELIMITER ;

-- Function tính tổng tiền thuê nhà thu được trong năm
DELIMITER //
CREATE FUNCTION GetTotalRentCollectedInYear(p_Year INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_rent DECIMAL(10, 2);
    
    SELECT SUM(Monthly_Rent * TIMESTAMPDIFF(MONTH, Start_Date, End_Date))
    INTO total_rent
    FROM Lease
    WHERE YEAR(Start_Date) = p_Year;
    
    RETURN total_rent;
END //
DELIMITER ;