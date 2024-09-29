--  Trigger để đảm bảo ngày bắt đầu thuê luôn trước ngày kết thúc thuê (Bảng Lease)
DELIMITER //
CREATE TRIGGER check_lease_dates BEFORE INSERT ON Lease
FOR EACH ROW
BEGIN
    IF NEW.Start_Date >= NEW.End_Date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Start_Date must be before End_Date.';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER check_lease_dates_update BEFORE UPDATE ON Lease
FOR EACH ROW
BEGIN
    IF NEW.Start_Date >= NEW.End_Date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Start_Date must be before End_Date.';
    END IF;
END;
//
DELIMITER ;

-- Trigger tự động cập nhật trạng thái hợp đồng khi đến hạn (Bảng Lease)
DELIMITER //
CREATE TRIGGER update_lease_status BEFORE INSERT ON Lease
FOR EACH ROW
BEGIN
    IF NEW.End_Date < CURDATE() THEN
        SET NEW.Status = 'Expired';
    ELSE
        SET NEW.Status = 'Active';
    END IF;
END;
//
DELIMITER ;

-- Trigger tự động cập nhật trạng thái thanh toán (Bảng Payment)
DELIMITER //
CREATE TRIGGER check_payment_status BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    IF NEW.Payment_Date IS NOT NULL THEN
        SET NEW.Status = 'Paid';
    ELSEIF NEW.Amount = 0 THEN
        SET NEW.Status = 'Pending';
    END IF;
END;
//
DELIMITER ;

-- Trigger để đảm bảo cư dân phải đủ 18 tuổi (Bảng Tenant)
DELIMITER //
CREATE TRIGGER check_tenant_age BEFORE INSERT ON Tenant
FOR EACH ROW
BEGIN
    DECLARE tenant_age INT;
    -- Tính toán tuổi của cư dân
    SET tenant_age = TIMESTAMPDIFF(YEAR, NEW.T_Date_of_Birth, CURDATE());

    -- Nếu tuổi nhỏ hơn 18, đưa ra lỗi
    IF tenant_age < 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tenant must be at least 18 years old.';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER check_tenant_age_update BEFORE UPDATE ON Tenant
FOR EACH ROW
BEGIN
    DECLARE tenant_age INT;
    -- Tính toán tuổi của cư dân
    SET tenant_age = TIMESTAMPDIFF(YEAR, NEW.T_Date_of_Birth, CURDATE());

    -- Nếu tuổi nhỏ hơn 18, đưa ra lỗi
    IF tenant_age < 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tenant must be at least 18 years old.';
    END IF;
END;
//
DELIMITER ;

