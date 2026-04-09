-- 1. Database Initialization
CREATE DATABASE IF NOT EXISTS clinic_management;
USE clinic_management;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinics;
SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(20)
);

CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(10, 2),
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description TEXT,
    amount DECIMAL(10, 2),
    datetime DATETIME,  
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

INSERT INTO clinics VALUES ('cnc-01', 'City Health', 'Pune', 'Maharashtra', 'India');
INSERT INTO customer VALUES ('cust-101', 'Jon Doe', '9876543210');
INSERT INTO clinic_sales VALUES ('ord-001', 'cust-101', 'cnc-01', 5000.00, '2021-09-23 12:00:00', 'Direct');
INSERT INTO expenses VALUES ('exp-001', 'cnc-01', 'Supplies', 1200.00, '2021-09-23 10:00:00');