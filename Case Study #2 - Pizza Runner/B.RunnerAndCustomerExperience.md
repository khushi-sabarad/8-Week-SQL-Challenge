# Case Study #2 - Pizza Runner 🍕
## B. Runner and Customer Experience 🏃

```sql
-- 1. How many runners signed up for each 1 week? (i.e. week starts 2021-01-01)
SELECT 
    WEEK(registration_date, 1) AS week,
    COUNT(*) AS runners_signed_up
FROM runners
GROUP BY week
ORDER BY week;

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?
SELECT
    r.runner_id,
    AVG(MINUTE(TIMEDIFF(r.pickup_time, c.order_time))) AS avg_time_min
FROM customer_orders c
JOIN  runner_orders r
	ON c.order_id = r.order_id
GROUP BY r.runner_id;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT
    c.pizza_count,
    AVG(MINUTE(TIMEDIFF(r.pickup_time, c.order_time))) AS avg_prep_time_min
FROM
    (SELECT
        order_id, order_time,
        COUNT(*) AS pizza_count
    FROM  customer_orders
    GROUP BY order_id,order_time) AS c
JOIN
    runner_orders r ON c.order_id = r.order_id
GROUP BY c.pizza_count;
-- More pizzas ordered result in longer preparation time.


-- 4. What was the average distance travelled for each customer?
SELECT c.customer_id, ROUND(AVG(r.distance_km),2)  AS avg_dist
FROM runner_orders r
JOIN customer_orders c ON r.order_id = c.order_id
GROUP BY c.customer_id;

-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration_mins) - MIN(duration_mins) AS diff
FROM runner_orders;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT
    runner_id,
    order_id,
    MAX(distance_km) AS distance_km,
    ROUND(MAX((duration_mins / 60)), 2) AS duration_hr,
    ROUND(AVG(distance_km / (duration_mins / 60)), 2) AS speed_kmh
FROM
    runner_orders
WHERE
    cancellation IS NULL
GROUP BY
    runner_id,order_id
ORDER BY
    runner_id;
/* As the distance increases, the time taken by the runner also increases.
Runner 2's speed is significantly higher compared to the other runners. */

-- 7. What is the successful delivery percentage for each runner?
SELECT
    runner_id,
    COUNT(CASE WHEN cancellation IS NULL THEN 1 END) AS successful_deliveries,
    COUNT(*) AS total_deliveries,
    ROUND((COUNT(CASE WHEN cancellation IS NULL THEN 1 END) / COUNT(*)) * 100,2) AS delivery_percentage
FROM
    runner_orders
GROUP BY
    runner_id;
```
