USE restaurant_db;

-- EXPLORE THE MENU_ITEMS TABLE----------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------

-- 1.View the menu_item table.
SELECT * FROM menu_items;

-- 2.Find the number of items on the menu.
SELECT COUNT(DISTINCT(item_name)) FROM menu_items;

-- 3.What are the least and most expensive items on the menu?
-- ------------First, to find least expensive item:-------------
SELECT * FROM menu_items
ORDER BY price;
-- ------------Next, to find most expensive item:---------------
SELECT * FROM menu_items
ORDER BY price DESC;

-- 4.How many italian dishes are on the menu ?
SELECT category, COUNT(item_name) AS Total_items
FROM menu_items
WHERE category = 'Italian';

-- 5.What are least and most expensive Italian dishes on the menu ?
-- --------------Now, for least expensive Italian item--------------------------
SELECT *
FROM menu_items
WHERE category = 'Italian'
ORDER BY price; 
-- --------------And, for most expensive Italian item--------------------------
SELECT *
FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC;
-- ----------------------------------------------------------------PROJECT DONE BY ANYAMAN PATRA---------
-- 6.How many dishes are in each category?
SELECT category, COUNT(item_name) AS Total_items
FROM menu_items
GROUP BY category
ORDER BY Total_items DESC; 

-- 7.What is the average dish price within each category?
SELECT category, ROUND(AVG(price),2) AS avg_dish_price
FROM menu_items
GROUP BY category
ORDER BY avg_dish_price DESC;


-- EXPLORE THE ORDERS TABLE--------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------

-- 1.View the order_details table.
SELECT * FROM order_details;

-- 2.What is the date range of the table?
SELECT TIMESTAMPDIFF(DAY, MIN(order_date), MAX(order_date)) AS Date_Range
FROM order_details;
-- OR----------------------------------------
SELECT TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS Date_Range
FROM order_details;
-- OR----------------------------------------
SELECT MIN(order_date), MAX(order_date) FROM order_details;
-- --------------------------------------------------------------------------PROJECT DONE BY ANYAMAN PATRA-----
-- 3.How many order were made within this date range?
SELECT COUNT(DISTINCT(order_id)) AS Total_orders FROM order_details;

-- 4.How many items were ordered within this date range?
SELECT COUNT(item_id) AS Total_items_ordered FROM order_details;

-- 5.Which orders had the most number of items?
SELECT order_id, COUNT(item_id) AS Total_items
FROM order_details
GROUP BY order_id
ORDER BY Total_items DESC;

-- 6.Which orders had more than 12 items?
SELECT order_id, COUNT(item_id) AS Total_items
FROM order_details
GROUP BY order_id
HAVING Total_items > 12
ORDER BY Total_items DESC;


-- 7.HOW MANY orders had more than 12 items?
-- In this case, just using the previous query as a subquery will give the desired result.
SELECT COUNT(*) FROM
(SELECT order_id, COUNT(item_id) AS Total_items
FROM order_details
GROUP BY order_id
HAVING Total_items > 12
ORDER BY Total_items DESC) AS Total_orders;


-- ANALYSIS OF CUSTOMER BEHAVIOR-------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------PROJECT DONE BY ANYAMAN PATRA--------

-- 1.Combine the menu_items and order_details tables into a single table.alter
SELECT *
FROM order_details AS A LEFT JOIN menu_items AS B
ON A.item_id = B.menu_item_id;

-- 2.What were the least and most ordered items? What categories were they in ?
-- ---------------------------Least ordered item-------------------------------
SELECT B.item_name, B.category, COUNT(B.item_name) AS Total_items_ordered
FROM order_details AS A LEFT JOIN menu_items AS B
ON A.item_id = B.menu_item_id
GROUP BY B.item_name, B.category
ORDER BY Total_items_ordered;
-- ---------------------------Most ordered item--------------------------------
SELECT B.item_name, B.category, COUNT(B.item_name) AS Total_items_ordered
FROM order_details AS A LEFT JOIN menu_items AS B
ON A.item_id = B.menu_item_id
GROUP BY B.item_name, B.category
ORDER BY Total_items_ordered DESC;

-- 3.What were the top 5 orders that spent the most money?
SELECT A.order_id, SUM(B.price) AS Total_price
FROM order_details AS A LEFT JOIN menu_items AS B
ON A.item_id = B.menu_item_id
GROUP BY A.order_id
ORDER BY Total_price DESC
LIMIT 5;

-- 4.View the details of the highest spend order.
SELECT *
FROM order_details AS A LEFT JOIN menu_items AS B
ON A.item_id = B.menu_item_id
WHERE order_id = 440;
-- 4a. If we want to see what are the categories only that the highest spend order included:
SELECT B.category, COUNT(A.item_id) AS Total_items
FROM order_details AS A LEFT JOIN menu_items AS B
ON A.item_id = B.menu_item_id
WHERE order_id = 440
GROUP BY B.category
ORDER BY Total_items DESC;


-- 5.View the details of the top 5 highest spend orders.
SELECT *
FROM order_details AS A LEFT JOIN menu_items AS B
ON A.item_id = B.menu_item_id
WHERE order_id IN (440,2075,1957,330,2675);

-- 5a.If we want to see what are the categories only that the 5 highest spend orders included TOGETHER:
SELECT B.category, COUNT(A.item_id) AS Total_items
FROM order_details AS A LEFT JOIN menu_items AS B
ON A.item_id = B.menu_item_id
WHERE order_id IN (440,2075,1957,330,2675)
GROUP BY B.category
ORDER BY Total_items DESC;

-- 5b.If we want to see what are the categories only that the 5 highest spend orders included INDIVIDUALLY:
SELECT A.order_id, B.category, COUNT(A.item_id) AS Total_items
FROM order_details AS A LEFT JOIN menu_items AS B
ON A.item_id = B.menu_item_id
WHERE order_id IN (440,2075,1957,330,2675)
GROUP BY B.category, A.order_id
ORDER BY A.order_id DESC, Total_items DESC;

-- -----------------------------------------------------------------------------------------------------------------
-- END OF PROJECT---------------------------------------------------------------PROJECT DONE BY ANYAMAN PATRA-------
-- -----------------------------------------------------------------------------------------------------------------