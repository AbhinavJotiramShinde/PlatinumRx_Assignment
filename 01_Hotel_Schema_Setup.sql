CREATE DATABASE IF NOT EXISTS hotel_management;
USE hotel_management;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE  IF NOT EXISTS users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(20),
    mail_id VARCHAR(100),
    billing_address TEXT
);

CREATE TABLE  IF NOT EXISTS items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10, 2)
);

CREATE TABLE  IF NOT EXISTS bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE  IF NOT EXISTS booking_commercials (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity DECIMAL(10, 2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

INSERT INTO users VALUES ('21wrcxuy-67erfn', 'John Doe', '97XXXXXXXX', 'john.doe@example.com', 'XX, Street Y, ABC City');
INSERT INTO items VALUES ('itm-a9e8-q8fu', 'Tawa Paratha', 18.00), ('itm-a07vh-aer8', 'Mix Veg', 89.00), ('itm-w978-23u4', 'Water', 20.00);
INSERT INTO bookings VALUES ('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn');
INSERT INTO booking_commercials VALUES 
('q34r-3q4o8-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu', 3),
('q3o4-ahf32-o2u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1);
-- Adding a few more items
INSERT INTO items VALUES ('itm-beef-123', 'Steak', 500.00), ('itm-wine-456', 'Red Wine', 600.00);
INSERT INTO bookings VALUES ('bk-new-789', '2021-11-15 10:00:00', 'rm-deluxe-101', '21wrcxuy-67erfn');
INSERT INTO booking_commercials VALUES 
('q789-nov', 'bk-new-789', 'bl-nov-001', '2021-11-15 13:00:00', 'itm-beef-123', 2),
('q101-oct', 'bk-new-789', 'bl-oct-002', '2021-10-10 14:00:00', 'itm-wine-456', 3);
