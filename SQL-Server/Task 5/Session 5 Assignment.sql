------------Task 5 -------------

-- Q1. Classify products into price categories
SELECT 
    product_name,
    list_price,
    CASE 
        WHEN list_price < 300 THEN 'Economy'
        WHEN list_price BETWEEN 300 AND 999 THEN 'Standard'
        WHEN list_price BETWEEN 1000 AND 2499 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_category
FROM production.products;

-- Q2. Order processing info with status descriptions and priority levels
SELECT 
    order_id,
    order_status,
    order_date,
    CASE order_status
        WHEN 1 THEN 'Order Received'
        WHEN 2 THEN 'In Preparation'
        WHEN 3 THEN 'Order Cancelled'
        WHEN 4 THEN 'Order Delivered'
    END AS status_description,
    CASE 
        WHEN order_status = 1 AND DATEDIFF(DAY, order_date, GETDATE()) > 5 THEN 'URGENT'
        WHEN order_status = 2 AND DATEDIFF(DAY, order_date, GETDATE()) > 3 THEN 'HIGH'
        ELSE 'NORMAL'
    END AS priority_level
FROM sales.orders;

-- Q3. Categorize staff by number of orders handled
SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    COUNT(o.order_id) AS orders_handled,
    CASE 
        WHEN COUNT(o.order_id) = 0 THEN 'New Staff'
        WHEN COUNT(o.order_id) BETWEEN 1 AND 10 THEN 'Junior Staff'
        WHEN COUNT(o.order_id) BETWEEN 11 AND 25 THEN 'Senior Staff'
        ELSE 'Expert Staff'
    END AS staff_level
FROM sales.staffs s
LEFT JOIN sales.orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;

-- Q4. Handle missing customer contact info
SELECT 
    customer_id,
    first_name,
    last_name,
    ISNULL(phone, 'Phone Not Available') AS phone,
    email,
    COALESCE(phone, email, 'No Contact Method') AS preferred_contact,
    street, city, state, zip_code
FROM sales.customers;

-- Q5. Calculate price per unit in stock safely for store_id = 1
SELECT 
    p.product_name,
    s.quantity,
    ISNULL(s.quantity, 0) AS safe_quantity,
    ISNULL(p.list_price / NULLIF(s.quantity, 0), 0) AS price_per_unit,
    CASE 
        WHEN s.quantity IS NULL THEN 'No Stock Info'
        WHEN s.quantity = 0 THEN 'Out of Stock'
        ELSE 'In Stock'
    END AS stock_status
FROM production.products p
LEFT JOIN production.stocks s ON p.product_id = s.product_id AND s.store_id = 1;

-- Q6. Format complete addresses safely
SELECT 
    customer_id,
    first_name,
    last_name,
    COALESCE(street, '') AS street,
    COALESCE(city, '') AS city,
    COALESCE(state, '') AS state,
    COALESCE(zip_code, '') AS zip_code,
    COALESCE(street, '') + ', ' + COALESCE(city, '') + ', ' + COALESCE(state, '') + ' ' + COALESCE(zip_code, '') AS formatted_address
FROM sales.customers;

-- Q7. CTE: Customers who spent more than $1,500
WITH customer_spending AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT 
    cs.customer_id,
    c.first_name + ' ' + c.last_name AS full_name,
    cs.total_spent
FROM customer_spending cs
JOIN sales.customers c ON cs.customer_id = c.customer_id
WHERE cs.total_spent > 1500
ORDER BY cs.total_spent DESC;

-- Q8. Multi-CTE: Category revenue and performance
WITH revenue_per_category AS (
    SELECT 
        p.category_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.order_items oi
    JOIN production.products p ON oi.product_id = p.product_id
    GROUP BY p.category_id
),
avg_order_value_per_category AS (
    SELECT 
        p.category_id,
        AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS avg_order_value
    FROM sales.order_items oi
    JOIN production.products p ON oi.product_id = p.product_id
    GROUP BY p.category_id
)
SELECT 
    c.category_name,
    r.total_revenue,
    a.avg_order_value,
    CASE 
        WHEN r.total_revenue > 50000 THEN 'Excellent'
        WHEN r.total_revenue > 20000 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance_rating
FROM revenue_per_category r
JOIN avg_order_value_per_category a ON r.category_id = a.category_id
JOIN production.categories c ON r.category_id = c.category_id;

-- Q9. Monthly sales trends with growth %
WITH monthly_sales AS (
    SELECT 
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS monthly_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
),
monthly_growth AS (
    SELECT 
        sales_year,
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (ORDER BY sales_year, sales_month) AS prev_month_revenue
    FROM monthly_sales
)
SELECT 
    sales_year,
    sales_month,
    monthly_revenue,
    prev_month_revenue,
    ROUND((monthly_revenue - prev_month_revenue) * 100.0 / NULLIF(prev_month_revenue, 0), 2) AS growth_percentage
FROM monthly_growth;
