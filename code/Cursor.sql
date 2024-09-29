-- Cursor lấy danh sách top 2 tiện ích được đặt nhiều nhất trong một tháng
DELIMITER //
CREATE PROCEDURE GetTop2AmenitiesBookedInMonth(
    IN p_Month INT,
    IN p_Year INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE amenity_name VARCHAR(255);
    DECLARE booking_count INT;

    -- Cursor để lấy top 2 tiện ích được đặt nhiều nhất
    DECLARE amenity_cursor CURSOR FOR
        SELECT a.Name, COUNT(b.Amenity_ID) AS Total_Bookings
        FROM Booking b
        JOIN Amenity a ON b.Amenity_ID = a.Amenity_ID
        WHERE MONTH(b.Start_Time) = p_Month AND YEAR(b.Start_Time) = p_Year
        GROUP BY a.Amenity_ID
        ORDER BY Total_Bookings DESC
        LIMIT 2;

    -- Truy vấn lỗi
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Mở cursor
    OPEN amenity_cursor;

    read_loop: LOOP
        FETCH amenity_cursor INTO amenity_name, booking_count;
        
        -- Kiểm tra điều kiện thoát khỏi vòng lặp
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- In ra tên tiện ích và số lượng đặt
        SELECT amenity_name AS Amenity, booking_count AS Total_Bookings;
    END LOOP;

    -- Đóng cursor
    CLOSE amenity_cursor;
END //
DELIMITER ;

-- Cursor cập nhật giá tiền cho từng payment
DELIMITER //
CREATE PROCEDURE UpdatePaymentAmount()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE p_lease_id INT;
    DECLARE p_monthly_rent DECIMAL(10, 2);

    -- Cursor để lấy từng payment và hợp đồng tương ứng
    DECLARE payment_cursor CURSOR FOR
        SELECT Payment.Lease_ID, Lease.Monthly_Rent
        FROM Payment
        JOIN Lease ON Payment.Lease_ID = Lease.Lease_ID;

    -- Truy vấn lỗi
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Mở cursor
    OPEN payment_cursor;

    read_loop: LOOP
        FETCH payment_cursor INTO p_lease_id, p_monthly_rent;
        
        -- Kiểm tra điều kiện thoát khỏi vòng lặp
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Cập nhật giá trị cho Amount
        UPDATE Payment
        SET Amount = p_monthly_rent
        WHERE Lease_ID = p_lease_id;
    END LOOP;

    -- Đóng cursor
    CLOSE payment_cursor;
END //
DELIMITER ;

-- Cursor để lấy danh sách hợp đồng hết hạn trong một tháng
DELIMITER //
CREATE PROCEDURE GetExpiringLeasesInMonth(
    IN p_Month INT,
    IN p_Year INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE tenant_name VARCHAR(255);
    DECLARE lease_end_date DATE;

    -- Cursor để lấy danh sách hợp đồng sắp hết hạn
    DECLARE lease_cursor CURSOR FOR
        SELECT t.T_Name, l.End_Date
        FROM Lease l
        JOIN Tenant t ON l.Tenant_ID = t.Tenant_ID
        WHERE MONTH(l.End_Date) = p_Month AND YEAR(l.End_Date) = p_Year;

    -- Truy vấn lỗi
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Mở cursor
    OPEN lease_cursor;

    read_loop: LOOP
        FETCH lease_cursor INTO tenant_name, lease_end_date;
        
        -- Kiểm tra điều kiện thoát khỏi vòng lặp
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- In ra tên cư dân và ngày hết hạn hợp đồng
        SELECT tenant_name AS Tenant, lease_end_date AS Lease_End_Date;
    END LOOP;

    -- Đóng cursor
    CLOSE lease_cursor;
END //
DELIMITER ;
