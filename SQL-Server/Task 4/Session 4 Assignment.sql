---------TAsk 4 ---------------

-- Q1. Count the total number of products in the database
SELECT COUNT(*) AS total_products
FROM production.products;

-- Q2. Find the average, minimum, and maximum price of all products
SELECT 
    AVG(list_price) AS avg_price,
    MIN(list_price) AS min_price,
    MAX(list_price) AS max_price
FROM production.products;

-- Q3. Count how many products are in each category
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

-- Q4. Find the total number of orders for each store
SELECT s.store_name, COUNT(o.order_id) AS total_orders
FROM sales.orders o
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY s.store_name;

-- Q5. Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers
SELECT 
    UPPER(first_name) AS upper_first_name,
    LOWER(last_name) AS lower_last_name
FROM sales.customers
ORDER BY customer_id
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Q6. Get the length of each product name. Show product name and its length for the first 10 products
SELECT 
    product_name, 
    LEN(product_name) AS name_length
FROM production.products
ORDER BY product_id
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Q7. Format customer phone numbers to show only the area code (first 3 digits) for customers 1-15
SELECT 
    customer_id,
    LEFT(phone, 3) AS area_code
FROM sales.customers
WHERE customer_id BETWEEN 1 AND 15;

-- Q8. Show the current date and extract the year and month from order dates for orders 1–10
SELECT 
    order_id,
    order_date,
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    GETDATE() AS current_dt
FROM sales.orders
WHERE order_id BETWEEN 1 AND 10;


-- Q9. Join products with their categories. Show product name and category name for first 10 products
SELECT 
    p.product_name, 
    c.category_name
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
ORDER BY p.product_id
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Q10. Join customers with their orders. Show customer name and order date for first 10 orders
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Q11. Show all products with their brand names, even if some products don't have brands
SELECT 
    p.product_name, 
    ISNULL(b.brand_name, 'No Brand') AS brand_name
FROM production.products p
LEFT JOIN production.brands b ON p.brand_id = b.brand_id;

-- Q12. Find products that cost more than the average product price
SELECT 
    product_name, 
    list_price
FROM production.products
WHERE list_price > (SELECT AVG(list_price) FROM production.products);

-- Q13. Find customers who have placed at least one order
SELECT 
    customer_id, 
    first_name + ' ' + last_name AS customer_name
FROM sales.customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM sales.orders);

-- Q14. For each customer, show their name and total number of orders
SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    (SELECT COUNT(*) FROM sales.orders o WHERE o.customer_id = c.customer_id) AS total_orders
FROM sales.customers c;

-- Q15. Create a simple view called easy_product_list
CREATE VIEW easy_product_list AS
SELECT 
    p.product_name, 
    c.category_name, 
    p.list_price
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id;

-- Then select all products from this view where price > 100
SELECT *
FROM easy_product_list
WHERE list_price > 100;

-- Q16. Create a view called customer_info
CREATE VIEW customer_info AS
SELECT 
    customer_id,
    first_name + ' ' + last_name AS full_name,
    email,
    city + ', ' + state AS location
FROM sales.customers;

-- Then use this view to find all customers from California
SELECT *
FROM customer_info
WHERE location LIKE '%, CA';

-- Q17. Find all products that cost between $50 and $200
SELECT 
    product_name, 
    list_price
FROM production.products
WHERE list_price BETWEEN 50 AND 200
ORDER BY list_price ASC;

-- Q18. Count how many customers live in each state
SELECT 
    state, 
    COUNT(*) AS customer_count
FROM sales.customers
GROUP BY state
ORDER BY customer_count DESC;

-- Q19. Find the most expensive product in each category
SELECT 
    c.category_name,
    p.product_name,
    p.list_price
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
WHERE p.list_price = (
    SELECT MAX(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
);

-- Q20. Show all stores and their cities, including the total number of orders from each store
SELECT 
    s.store_name,
    s.city,
    COUNT(o.order_id) AS order_count
FROM sales.stores s
LEFT JOIN sales.orders o ON s.store_id = o.store_id
GROUP BY s.store_name, s.city;
