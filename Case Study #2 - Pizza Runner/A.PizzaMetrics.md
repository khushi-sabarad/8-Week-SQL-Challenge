# Case Study #2 - Pizza Runner 🍕
## A. Pizza Metrics


```sql
-- 1. How many pizzas were ordered?
SELECT COUNT(*) FROM customer_orders;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id))
FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(*)
FROM runner_orders
WHERE cancellation IS NULL GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT c.pizza_id, COUNT(*)
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.pizza_id;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT c.customer_id, p.pizza_name, COUNT(*)
FROM pizza_names p
JOIN customer_orders c ON p.pizza_id = c.pizza_id
GROUP BY p.pizza_name, c.customer_id
ORDER BY c.customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT c.order_id, COUNT(c.pizza_id)
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.order_id
ORDER BY COUNT(c.pizza_id) DESC LIMIT 1;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
    c.customer_id,
    SUM(IF(c.exclusions IS NOT NULL OR c.extras IS NOT NULL, 1, 0)) AS pizzas_with_changes,
    SUM(IF(c.exclusions IS NULL AND c.extras IS NULL, 1, 0)) AS pizzas_with_no_changes
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT 
    COUNT(*) AS pizzas_with_changes
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE 
    r.cancellation IS NULL
    AND c.exclusions IS NOT NULL
    AND c.extras IS NOT NULL;

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT
 -- DATE(order_time) AS order_date,
    HOUR(order_time) AS order_hour,
    COUNT(*) AS total_pizzas_ordered
FROM customer_orders
GROUP BY order_hour
ORDER BY order_hour;

-- 10. What was the volume of orders for each day of the week?
SELECT DAYNAME(order_time) AS day,
        COUNT(*) AS total_pizzas_ordered
FROM customer_orders
GROUP BY day;
```
