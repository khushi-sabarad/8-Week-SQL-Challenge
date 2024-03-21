# Case Study #2 - Pizza Runner 🍕
## A. Pizza Metrics

1. How many pizzas were ordered?
```sql
SELECT COUNT(*) FROM customer_orders;
```
![image](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/ebb06d8b-9659-4194-ba89-d46164ab065d)

***
2. How many unique customer orders were made?
```sql
SELECT COUNT(DISTINCT(order_id))
FROM customer_orders;
```
![image](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/45755d0f-0f4e-4420-b92c-10f2cf77f68b)

***

3. How many successful orders were delivered by each runner?
```sql
SELECT runner_id, COUNT(*)
FROM runner_orders
WHERE cancellation IS NULL GROUP BY runner_id;
```
![image](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/fa25890e-9554-4159-b92d-748e5f4b579a)

***

4. How many of each type of pizza was delivered?
```sql
SELECT c.pizza_id, COUNT(*)
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.pizza_id;
```
![image](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/cf2fdb99-e6ab-471f-828e-3fc19ff8b554)

***

5. How many Vegetarian and Meatlovers were ordered by each customer?
```sql
SELECT c.customer_id, p.pizza_name, COUNT(*)
FROM pizza_names p
JOIN customer_orders c ON p.pizza_id = c.pizza_id
GROUP BY p.pizza_name, c.customer_id
ORDER BY c.customer_id;
```
![image](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/0a909667-7afa-4d2d-9e3b-cad01ba75462)

***

6. What was the maximum number of pizzas delivered in a single order?
```sql
SELECT c.order_id, COUNT(c.pizza_id)
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.order_id
ORDER BY COUNT(c.pizza_id) DESC LIMIT 1;

```
![image](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/caed34bd-a336-4b8c-b69e-00f025477ed0)

***

7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```sql
SELECT 
    c.customer_id,
    SUM(IF(c.exclusions IS NOT NULL OR c.extras IS NOT NULL, 1, 0)) AS pizzas_with_changes,
    SUM(IF(c.exclusions IS NULL AND c.extras IS NULL, 1, 0)) AS pizzas_with_no_changes
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.customer_id;
```
![image](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/856939ff-fb30-49bc-a7e0-bb6fd1a9e657)

***

8. How many pizzas were delivered that had both exclusions and extras?
```sql
SELECT 
    COUNT(*) AS pizzas_with_changes
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE 
    r.cancellation IS NULL
    AND c.exclusions IS NOT NULL
    AND c.extras IS NOT NULL;
```
![image](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/9082577e-50c1-4a84-bcc4-a7c80b779ee5)

***

9. What was the total volume of pizzas ordered for each hour of the day?
```sql
SELECT
 -- DATE(order_time) AS order_date,
    HOUR(order_time) AS order_hour,
    COUNT(*) AS total_pizzas_ordered
FROM customer_orders
GROUP BY order_hour
ORDER BY order_hour;
```
![image](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/25dbe80a-7a97-48b1-a089-84ea19f15a02)

***

10. What was the volume of orders for each day of the week?
```sql
SELECT DAYNAME(order_time) AS day,
        COUNT(*) AS total_pizzas_ordered
FROM customer_orders
GROUP BY day;
```
![image](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/da48ae95-2b83-437f-a517-20c198f92e54)

***
