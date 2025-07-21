---------TAsk 6 ---------------



-- 1. Customer Spending Analysis
DECLARE @custId INT = 1;
DECLARE @totalSpent DECIMAL(10,2);
SELECT @totalSpent = SUM(oi.quantity * oi.list_price * (1 - oi.discount))
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.customer_id = @custId;

IF @totalSpent > 5000
    PRINT 'Customer ' + CAST(@custId AS VARCHAR) + ' is a VIP customer. Total spent: $' + CAST(@totalSpent AS VARCHAR);
ELSE
    PRINT 'Customer ' + CAST(@custId AS VARCHAR) + ' is a regular customer. Total spent: $' + CAST(@totalSpent AS VARCHAR);

-- 2. Product Price Threshold Report
DECLARE @threshold DECIMAL(10,2) = 1500;
DECLARE @count INT;
SELECT @count = COUNT(*) FROM production.products WHERE list_price > @threshold;
PRINT 'Products above $' + CAST(@threshold AS VARCHAR) + ': ' + CAST(@count AS VARCHAR);

-- 3. Staff Performance Calculator
DECLARE @staffId INT = 2, @year INT = 2017, @staffSales DECIMAL(10,2);
SELECT @staffSales = SUM(oi.quantity * oi.list_price * (1 - oi.discount))
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.staff_id = @staffId AND YEAR(o.order_date) = @year;
PRINT 'Total sales for staff ID ' + CAST(@staffId AS VARCHAR) + ' in ' + CAST(@year AS VARCHAR) + ': $' + CAST(@staffSales AS VARCHAR);

-- 4. Global Variables Information
SELECT 
  @@SERVERNAME AS ServerName,
  @@VERSION AS SQLVersion,
  @@ROWCOUNT AS RowsAffected;

-- 5. Inventory Level Check
DECLARE @qty INT;
SELECT @qty = quantity FROM production.stocks WHERE store_id = 1 AND product_id = 1;
IF @qty > 20
    PRINT 'Well stocked';
ELSE IF @qty BETWEEN 10 AND 20
    PRINT 'Moderate stock';
ELSE
    PRINT 'Low stock - reorder needed';

-- 6. WHILE Loop to Restock Low-Stock Items
DECLARE @batchSize INT = 3, @processed INT = 0;
WHILE EXISTS (SELECT TOP 1 * FROM production.stocks WHERE quantity < 5 AND product_id NOT IN (SELECT TOP (@processed) product_id FROM production.stocks WHERE quantity < 5 ORDER BY product_id))
BEGIN
    UPDATE TOP (@batchSize) production.stocks
    SET quantity = quantity + 10
    WHERE quantity < 5 AND product_id NOT IN (SELECT TOP (@processed) product_id FROM production.stocks WHERE quantity < 5 ORDER BY product_id);
    SET @processed += @batchSize;
    PRINT 'Processed batch of ' + CAST(@batchSize AS VARCHAR) + ' low-stock items.';
END

-- 7. Product Price Categorization
SELECT product_id, product_name, list_price,
  CASE 
    WHEN list_price < 300 THEN 'Budget'
    WHEN list_price BETWEEN 300 AND 800 THEN 'Mid-Range'
    WHEN list_price BETWEEN 801 AND 2000 THEN 'Premium'
    ELSE 'Luxury'
  END AS PriceCategory
FROM production.products;

-- 8. Customer Order Validation
IF EXISTS (SELECT 1 FROM sales.customers WHERE customer_id = 5)
BEGIN
    SELECT COUNT(*) AS OrderCount FROM sales.orders WHERE customer_id = 5;
END
ELSE
BEGIN
    PRINT 'Customer ID 5 does not exist.';
END

-- 9. Scalar Function: CalculateShipping
CREATE OR ALTER FUNCTION dbo.CalculateShipping(@total DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN (
        CASE 
            WHEN @total > 100 THEN 0
            WHEN @total BETWEEN 50 AND 99.99 THEN 5.99
            ELSE 12.99
        END
    );
END

-- 10. Inline Table-Valued Function: GetProductsByPriceRange
CREATE OR ALTER FUNCTION dbo.GetProductsByPriceRange(@minPrice DECIMAL(10,2), @maxPrice DECIMAL(10,2))
RETURNS TABLE
AS
RETURN
    SELECT p.product_id, p.product_name, p.list_price, b.brand_name, c.category_name
    FROM production.products p
    JOIN production.brands b ON p.brand_id = b.brand_id
    JOIN production.categories c ON p.category_id = c.category_id
    WHERE p.list_price BETWEEN @minPrice AND @maxPrice;

-- 11. Multi-Statement Function: GetCustomerYearlySummary
CREATE OR ALTER FUNCTION dbo.GetCustomerYearlySummary(@custId INT)
RETURNS @summary TABLE (Year INT, TotalOrders INT, TotalSpent DECIMAL(10,2), AvgOrderValue DECIMAL(10,2))
AS
BEGIN
    INSERT INTO @summary
    SELECT YEAR(o.order_date), COUNT(DISTINCT o.order_id), 
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)),
           AVG(SUM(oi.quantity * oi.list_price * (1 - oi.discount))) OVER(PARTITION BY YEAR(o.order_date))
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @custId
    GROUP BY YEAR(o.order_date);
    RETURN;
END
-- 12. Scalar Function: CalculateBulkDiscount
CREATE OR ALTER FUNCTION dbo.CalculateBulkDiscount(@quantity INT)
RETURNS DECIMAL(4,2)
AS
BEGIN
    RETURN (
        CASE
            WHEN @quantity BETWEEN 1 AND 2 THEN 0
            WHEN @quantity BETWEEN 3 AND 5 THEN 0.05
            WHEN @quantity BETWEEN 6 AND 9 THEN 0.10
            ELSE 0.15
        END
    );
END

-- 13. Procedure: Customer Order History
CREATE OR ALTER PROCEDURE sp_GetCustomerOrderHistory
    @CustomerId INT,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
    SELECT o.order_id, o.order_date,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS OrderTotal
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @CustomerId
          AND (@StartDate IS NULL OR o.order_date >= @StartDate)
          AND (@EndDate IS NULL OR o.order_date <= @EndDate)
    GROUP BY o.order_id, o.order_date;
END

-- 14. Procedure: Inventory Restock
CREATE OR ALTER PROCEDURE sp_RestockProduct
    @storeId INT,
    @productId INT,
    @restockQty INT,
    @oldQty INT OUTPUT,
    @newQty INT OUTPUT,
    @success BIT OUTPUT
AS
BEGIN
    BEGIN TRY
        SELECT @oldQty = quantity FROM production.stocks WHERE store_id = @storeId AND product_id = @productId;
        UPDATE production.stocks
        SET quantity = quantity + @restockQty
        WHERE store_id = @storeId AND product_id = @productId;

        SELECT @newQty = quantity FROM production.stocks WHERE store_id = @storeId AND product_id = @productId;
        SET @success = 1;
    END TRY
    BEGIN CATCH
        SET @success = 0;
    END CATCH
END

-- 15. Procedure: Order Processing
CREATE OR ALTER PROCEDURE sp_ProcessNewOrder
    @customerId INT,
    @productId INT,
    @quantity INT,
    @storeId INT
AS
BEGIN
    DECLARE @orderId INT, @itemId INT = 1, @staffId INT = 1, @price DECIMAL(10,2), @discount DECIMAL(4,2);
    BEGIN TRANSACTION;
    BEGIN TRY
        SET @staffId = (SELECT TOP 1 staff_id FROM sales.staffs WHERE store_id = @storeId);
        INSERT INTO sales.orders(customer_id, order_status, order_date, required_date, store_id, staff_id)
        VALUES(@customerId, 1, GETDATE(), DATEADD(DAY, 5, GETDATE()), @storeId, @staffId);

        SET @orderId = SCOPE_IDENTITY();
        SELECT @price = list_price FROM production.products WHERE product_id = @productId;
        SET @discount = dbo.CalculateBulkDiscount(@quantity);

        INSERT INTO sales.order_items(order_id, item_id, product_id, quantity, list_price, discount)
        VALUES(@orderId, @itemId, @productId, @quantity, @price, @discount);

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Error processing order';
    END CATCH
END

-- 16. Procedure: Dynamic Product Search
CREATE OR ALTER PROCEDURE sp_SearchProducts
    @nameTerm VARCHAR(255) = NULL,
    @categoryId INT = NULL,
    @minPrice DECIMAL(10,2) = NULL,
    @maxPrice DECIMAL(10,2) = NULL,
    @sortColumn VARCHAR(50) = 'list_price'
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'SELECT product_id, product_name, list_price FROM production.products WHERE 1=1';

    IF @nameTerm IS NOT NULL
        SET @sql += ' AND product_name LIKE ''%' + @nameTerm + '%''';
    IF @categoryId IS NOT NULL
        SET @sql += ' AND category_id = ' + CAST(@categoryId AS VARCHAR);
    IF @minPrice IS NOT NULL
        SET @sql += ' AND list_price >= ' + CAST(@minPrice AS VARCHAR);
    IF @maxPrice IS NOT NULL
        SET @sql += ' AND list_price <= ' + CAST(@maxPrice AS VARCHAR);

    SET @sql += ' ORDER BY ' + QUOTENAME(@sortColumn);
    EXEC sp_executesql @sql;
END

-- 17. Staff Bonus Calculation
DECLARE @qStart DATE = '2024-01-01', @qEnd DATE = '2024-03-31';
DECLARE @bonusRateLow FLOAT = 0.03, @bonusRateMid FLOAT = 0.05, @bonusRateHigh FLOAT = 0.1;

SELECT s.staff_id, s.first_name, s.last_name,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales,
       CASE 
         WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 50000 THEN 'High'
         WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 20000 THEN 'Mid'
         ELSE 'Low'
       END AS Tier,
       CASE 
         WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 50000 THEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonusRateHigh
         WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 20000 THEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonusRateMid
         ELSE SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * @bonusRateLow
       END AS Bonus
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.staffs s ON o.staff_id = s.staff_id
WHERE o.order_date BETWEEN @qStart AND @qEnd
GROUP BY s.staff_id, s.first_name, s.last_name;

-- 18. Smart Inventory Management
SELECT s.store_id, s.product_id, s.quantity,
  CASE 
    WHEN s.quantity < 5 AND p.category_id IN (35, 36, 37) THEN 'Reorder 20 units'
    WHEN s.quantity < 5 THEN 'Reorder 10 units'
    WHEN s.quantity BETWEEN 5 AND 15 THEN 'Monitor closely'
    ELSE 'Stock sufficient'
  END AS Action
FROM production.stocks s
JOIN production.products p ON s.product_id = p.product_id;

-- 19. Customer Loyalty Tier Assignment
SELECT c.customer_id, c.first_name, c.last_name,
       ISNULL(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS total_spent,
       CASE
         WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 10000 THEN 'Platinum'
         WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 5000 THEN 'Gold'
         WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 1000 THEN 'Silver'
         WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) IS NULL THEN 'No Orders'
         ELSE 'Bronze'
       END AS Loyalty_Tier
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
LEFT JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 20. Product Lifecycle Management
CREATE OR ALTER PROCEDURE sp_DiscontinueProduct
    @productId INT,
    @replacementId INT = NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM sales.order_items oi
               JOIN sales.orders o ON o.order_id = oi.order_id
               WHERE oi.product_id = @productId AND o.order_status IN (1, 2))
    BEGIN
        PRINT 'Product has pending orders. Cannot discontinue.';
        RETURN;
    END

    IF @replacementId IS NOT NULL
    BEGIN
        UPDATE sales.order_items SET product_id = @replacementId WHERE product_id = @productId;
        PRINT 'Product replaced in existing orders.';
    END

    DELETE FROM production.stocks WHERE product_id = @productId;
    DELETE FROM production.products WHERE product_id = @productId;

    PRINT 'Product discontinued and inventory cleared.';
END