CREATE DATABASE dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INT);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INT,
  product_name VARCHAR(5),
  price INT);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

--------------------------------------------
--Solution for Case Study #1 - Danny's Diner
--------------------------------------------
use dannys_diner;

--1. What is the total amount each customer spent at the restaurant?

SELECT s.customer_id, SUM(m.price) AS total_amount_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;


--2. How many days has each customer visited the restaurant?

SELECT customer_id, COUNT(DISTINCT order_date) AS days_visited
FROM sales
GROUP BY customer_id;

--3. What was the first item from the menu purchased by each customer?

SELECT s.customer_id, 
  (SELECT m.product_name
  FROM sales s_sub
  JOIN menu m ON s_sub.product_id = m.product_id
  WHERE s_sub.customer_id = s.customer_id
  ORDER BY s_sub.order_date
  LIMIT 1) AS first_item
FROM (SELECT DISTINCT customer_id FROM sales) as s;


--4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT m.product_name AS most_purchased_item,
    COUNT(*) AS purchase_count,
    CONCAT(COUNT(*), '/', (SELECT COUNT(*) FROM sales)) AS purchase_fraction
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1;


--5. Which item was the most popular for each customer?

SELECT customer_id,
    GROUP_CONCAT(most_popular_item) AS most_popular_items,
    max_purchase_count
FROM
    ( SELECT s.customer_id, m.product_name AS most_popular_item,
      COUNT(*) AS purchase_count,
      MAX(COUNT(*)) OVER (PARTITION BY s.customer_id) AS max_purchase_count
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
    ) AS subquery
WHERE purchase_count=max_purchase_count
GROUP BY customer_id, max_purchase_count;


--6. Which item was purchased first by the customer after they became a member?

SELECT s.customer_id,
    mem.join_date,
    s.order_date,
    m.product_name,
    m.price
FROM  sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mem ON mem.customer_id = s.customer_id
WHERE s.order_date = (
        SELECT MIN(order_date)
        FROM sales
        WHERE customer_id = s.customer_id
          AND order_date > mem.join_date )
ORDER BY s.customer_id;


--7. Which item was purchased just before the customer became a member?

SELECT s.customer_id,
    mem.join_date,
    s.order_date,
    m.product_name,
    m.price
FROM  sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mem ON mem.customer_id = s.customer_id
WHERE s.order_date = (
        SELECT MAX(order_date)
        FROM sales
        WHERE customer_id = s.customer_id
          AND order_date < mem.join_date )
ORDER BY s.customer_id;


--8. What is the total items and amount spent for each member before they became a member?

SELECT 
    s.customer_id,
    GROUP_CONCAT(menu.product_name ORDER BY s.order_date DESC) AS ordered_items,
    COUNT(s.product_id) AS total_items, 
    SUM(menu.price) AS total_sales
FROM sales s
JOIN members m ON s.customer_id = m.customer_id
JOIN menu ON s.product_id = menu.product_id
WHERE s.order_date < m.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;


--9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT s.customer_id,
        SUM (IF(m.product_name = 'sushi', (menu.price * 2) * 10, menu.price * 10)) AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;


--10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

WITH cte_dates AS (
    SELECT *,
           DATE_ADD(join_date, INTERVAL 7 DAY) AS join_week,
           LAST_DAY('2021-01-31') AS jan_end
    FROM members
)
SELECT
    s.customer_id,
    SUM(
        CASE
            WHEN m.product_name = 'sushi' OR s.order_date BETWEEN cte.join_date AND cte.join_week THEN m.price * 20
            ELSE m.price * 10
        END
    ) AS points_january
FROM cte_dates cte
JOIN sales s ON cte.customer_id = s.customer_id
JOIN menu m ON m.product_id = s.product_id
WHERE s.order_date < cte.jan_end
GROUP BY s.customer_id
ORDER BY s.customer_id;


--------------------------------------------
--Bonus Questions
--------------------------------------------
--Generate some basic datasets so Danny's team can easily inspect the data without needing to use SQL.

--1. Join All The Things: Generate a table with customer_id, order_date, product_name, price, member (Y/N)

SELECT
    s.customer_id,
    s.order_date,
    menu.product_name,
    menu.price,
    CASE
        WHEN m.join_date  <= s.order_date THEN 'Y'
        ELSE 'N'
    END AS member
FROM sales s
LEFT JOIN members m ON s.customer_id = m.customer_id
JOIN menu ON s.product_id = menu.product_id
ORDER BY
    s.customer_id,
    s.order_date,
    menu.product_name;


--2. Rank All The Things

WITH member_data AS (
  SELECT
    s.customer_id,
    s.order_date,
    menu.product_name,
    menu.price,
    CASE
        WHEN m.join_date  <= s.order_date THEN 'Y'
        ELSE 'N'
    END AS member
FROM sales s
LEFT JOIN members m ON s.customer_id = m.customer_id
JOIN menu ON s.product_id = menu.product_id
ORDER BY
    s.customer_id,
    s.order_date,
    menu.product_name
)

SELECT *, 
  CASE
    WHEN member = 'N' then NULL
    ELSE RANK () OVER (
      PARTITION BY customer_id, member ORDER BY order_date) END AS ranking
FROM member_data;
--------------------------------------------
