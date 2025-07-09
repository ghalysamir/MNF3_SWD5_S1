
----Task 1 – Create the DDL (Data Definition Language) for Company ERD
CREATE SCHEMA HR;
GO


CREATE TABLE HR.Department (
    DNum INT PRIMARY KEY,
    DName VARCHAR(50) NOT NULL,
    Locations VARCHAR(100) NOT NULL,
    ManagerSSN CHAR(9) UNIQUE NULL, 
    Hiring_date DATE NOT NULL
);
GO


CREATE TABLE HR.Employee (
    SSN CHAR(9) PRIMARY KEY,
    Fname VARCHAR(30) NOT NULL,
    Lname VARCHAR(30) NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    Birth_date DATE NOT NULL,
    DNum INT NOT NULL,
    SupervisorSSN CHAR(9) NULL, 
    
    CONSTRAINT FK_EmployeeDept FOREIGN KEY (DNum) REFERENCES HR.Department(DNum)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO


ALTER TABLE HR.Employee
ADD CONSTRAINT FK_Supervisor FOREIGN KEY (SupervisorSSN) REFERENCES HR.Employee(SSN)
; 
GO


ALTER TABLE HR.Department
ADD CONSTRAINT FK_Manager FOREIGN KEY (ManagerSSN) REFERENCES HR.Employee(SSN); 
GO

CREATE TABLE HR.Project (
    PNum INT PRIMARY KEY,
    PName VARCHAR(50) NOT NULL,
    City VARCHAR(50),
    DNum INT NOT NULL,
    CONSTRAINT FK_ProjDept FOREIGN KEY (DNum) REFERENCES HR.Department(DNum)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

CREATE TABLE HR.Works_On (
    SSN CHAR(9),
    PNum INT,
    Work_hr INT CHECK (Work_hr >= 0),
    PRIMARY KEY (SSN, PNum),
    CONSTRAINT FK_WorkEmp FOREIGN KEY (SSN) REFERENCES HR.Employee(SSN)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_WorkProj FOREIGN KEY (PNum) REFERENCES HR.Project(PNum)
       
);
GO

CREATE TABLE HR.Dependent (
    Name VARCHAR(50),
    SSN CHAR(9),
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    Birthdate DATE NOT NULL,
    PRIMARY KEY (Name, SSN),
    CONSTRAINT FK_DependentEmp FOREIGN KEY (SSN) REFERENCES HR.Employee(SSN)
        ON DELETE CASCADE ON UPDATE CASCADE
);

---------------------------------------------------------
---Task 2 – SQL Queries on StoreDB

-- 1. List all products with list price greater than 1000
SELECT product_name, list_price
FROM production.products
WHERE list_price > 1000;

-- 2 .Get customers from "CA" or "NY" states
SELECT *
FROM sales.customers
WHERE state IN ('CA', 'NY');

-- 3 .Retrieve all orders placed in 2023
SELECT *
FROM sales.orders
WHERE YEAR(order_date) = 2023;

-- 4. Show customers whose emails end with @gmail.com
SELECT *
FROM sales.customers
WHERE email LIKE '%@gmail.com';

-- 5. Show all inactive staff
SELECT *
FROM sales.staffs
WHERE active = 0;

-- 6. List top 5 most expensive products
SELECT TOP 5 product_name, list_price
FROM production.products
ORDER BY list_price DESC;

-- 7. Show latest 10 orders sorted by date
SELECT TOP 10 *
FROM sales.orders
ORDER BY order_date DESC;

-- 8. Retrieve the first 3 customers alphabetically by last name
SELECT TOP 3 *
FROM sales.customers
ORDER BY last_name ASC;

-- 9. Find customers who did not provide a phone number
SELECT *
FROM sales.customers
WHERE phone IS NULL OR phone = '';

-- 10. Show all staff who have a manager assigned
SELECT *
FROM sales.staffs
WHERE manager_id IS NOT NULL;

-- 11. Count number of products in each category
SELECT category_id, COUNT(*) AS product_count
FROM production.products
GROUP BY category_id;

-- 12. Count number of customers in each state
SELECT state, COUNT(*) AS customer_count
FROM sales.customers
GROUP BY state;

-- 13. Get average list price of products per brand
SELECT brand_id, AVG(list_price) AS avg_price
FROM production.products
GROUP BY brand_id;

-- 14. Show number of orders per staff
SELECT staff_id, COUNT(*) AS orders_count
FROM sales.orders
GROUP BY staff_id;

-- 15. Find customers who made more than 2 orders
SELECT customer_id, COUNT(*) AS order_count
FROM sales.orders
GROUP BY customer_id
HAVING COUNT(*) > 2;

-- 16. Products priced between 500 and 1500
SELECT product_name, list_price
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;

-- 17. Customers in cities starting with "S"
SELECT *
FROM sales.customers
WHERE city LIKE 'S%';

-- 18. Orders with order_status either 2 or 4
SELECT *
FROM sales.orders
WHERE order_status IN (2, 4);

-- 19. Products from category_id IN (1, 2, 3)
SELECT *
FROM production.products
WHERE category_id IN (1, 2, 3);

-- 20. Staff working in store_id = 1 OR without phone number
SELECT *
FROM sales.staffs
WHERE store_id = 1 OR phone IS NULL OR phone = '';