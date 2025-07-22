------------Task 7 -------------

-- Q1. Non-clustered index on customer email
CREATE NONCLUSTERED INDEX idx_customers_email
ON sales.customers(email);

-- Q2. Composite index on category_id and brand_id in products
CREATE NONCLUSTERED INDEX idx_products_category_brand
ON production.products(category_id, brand_id);

-- Q3. Index on order_date including extra columns
CREATE NONCLUSTERED INDEX idx_orders_order_date_include
ON sales.orders(order_date)
INCLUDE(customer_id, store_id, order_status);

-- Required Tables for Trigger Questions

-- Customer activity log
CREATE TABLE sales.customer_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    action VARCHAR(50),
    log_date DATETIME DEFAULT GETDATE()
);

-- Price history tracking
CREATE TABLE production.price_history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date DATETIME DEFAULT GETDATE(),
    changed_by VARCHAR(100)
);

-- Order audit trail
CREATE TABLE sales.order_audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    customer_id INT,
    store_id INT,
    staff_id INT,
    order_date DATE,
    audit_timestamp DATETIME DEFAULT GETDATE()
);

-- Q4. Trigger: Welcome log for new customers
GO
CREATE TRIGGER trg_customer_insert_log
ON sales.customers
AFTER INSERT
AS
BEGIN
    INSERT INTO sales.customer_log(customer_id, action)
    SELECT customer_id, 'WELCOME' FROM inserted;
END;
GO
-- Q5. Trigger: Log price changes for products
CREATE TRIGGER trg_price_update_log
ON production.products
AFTER UPDATE
AS
BEGIN
    IF UPDATE(list_price)
    BEGIN
        INSERT INTO production.price_history(product_id, old_price, new_price, changed_by)
        SELECT d.product_id, d.list_price, i.list_price, SYSTEM_USER
        FROM deleted d
        JOIN inserted i ON d.product_id = i.product_id
        WHERE d.list_price <> i.list_price;
    END
END;

-- Q6. INSTEAD OF DELETE Trigger: Prevent category deletion
GO
CREATE TRIGGER trg_prevent_category_delete
ON production.categories
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN production.products p ON d.category_id = p.category_id
    )
    BEGIN
        RAISERROR ('Cannot delete category that has products.', 16, 1);
        RETURN;
    END

    DELETE FROM production.categories
    WHERE category_id IN (SELECT category_id FROM deleted);
END;
GO

-- Q7. Trigger: Reduce stock when new order_item inserted
CREATE TRIGGER trg_reduce_stock_on_order
ON sales.order_items
AFTER INSERT
AS
BEGIN
    UPDATE s
    SET s.quantity = s.quantity - i.quantity
    FROM production.stocks s
    JOIN inserted i 
        ON s.product_id = i.product_id 
        AND s.store_id = (
            SELECT store_id FROM sales.orders WHERE order_id = i.order_id
        );
END;

-- Q8. Trigger: Log new orders in audit table
GO
CREATE TRIGGER trg_order_audit_insert
ON sales.orders
AFTER INSERT
AS
BEGIN
    INSERT INTO sales.order_audit(order_id, customer_id, store_id, staff_id, order_date)
    SELECT order_id, customer_id, store_id, staff_id, order_date
    FROM inserted;
END;
