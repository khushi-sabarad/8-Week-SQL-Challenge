# Case Study #1 - Danny's Diner🍜
<img src="https://8weeksqlchallenge.com/images/case-study-designs/1.png" alt="Image" width="300" height="310">

 ***

## Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: 🍣sushi, 🍛 curry and 🍜ramen.

## Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. This deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers. 

**ERD of the 3 datasets Danny shared:** 

<img width="520" alt="case1 ERD" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/9b767443-f50d-4752-ab57-39b44ccb022a">

[Click here](https://8weeksqlchallenge.com/case-study-1/) to learn more about the case study in detail.

***
## Questions with Solutions
(I used MYSQL 8.0 Command Line Client to solve these) 

1. What is the total amount each customer spent at the restaurant?
```sql
SELECT s.customer_id, SUM(m.price) AS total_amount_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;
```
![case1 op](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/b8f7b777-6844-46a1-af2b-88dc5091573b)

***

2. How many days has each customer visited the restaurant?
```sql
SELECT customer_id, COUNT(DISTINCT order_date) AS days_visited
FROM sales
GROUP BY customer_id;
```
<img width="212" alt="case1 op2" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/63ae743b-d81c-4576-8f09-646183cae45d">

***

3. What was the first item from the menu purchased by each customer?
```sql
SELECT s.customer_id, 
  (SELECT m.product_name
  FROM sales s_sub
  JOIN menu m ON s_sub.product_id = m.product_id
  WHERE s_sub.customer_id = s.customer_id
  ORDER BY s_sub.order_date
  LIMIT 1) AS first_item
FROM (SELECT DISTINCT customer_id FROM sales) as s;
```
<img width="208" alt="case1 op3" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/730d7dd5-02d1-4a3d-af83-7636e5bd1a85">

Side Note: theres no datetime in the dataset, so i am assuming that the first item ordered is the item in the first row of the date. {REWRITE THIS SENTENCE TO WORD IT PROPERLY)

***

4. What is the most purchased item on the menu and how many times did all customers purchase it?
```sql
SELECT m.product_name AS most_purchased_item,
    COUNT(*) AS purchase_count,
    CONCAT(COUNT(*), '/', (SELECT COUNT(*) FROM sales)) AS purchase_fraction
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1;
```
<img width="431" alt="case1 op4" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/f23fffc3-2878-4c96-89f3-6b38270c48d3">

***

5. Which item was the most popular for each customer?
```sql
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
```
<img width="406" alt="case1 op5" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/3c0797c9-4536-4986-a47a-48cc489d014c">

***

6. Which item was purchased first by the customer after they became a member?
```sql
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

```
<img width="416" alt="case1 op6" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/f1b6d9b8-82c2-4d82-9415-a71d7e07d51c">

***
7. Which item was purchased just before the customer became a member?
```sql
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
```

<img width="430" alt="case1 op7" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/41dbf23f-f1c7-4b49-9d8f-9c59e1434eff">

***
8. What are the total items and amount spent for each member before they became a member?
```sql
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
```
<img width="410" alt="case1 op8" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/0dca2be2-7069-4e76-816a-cce3075226ad">

***
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql
SELECT s.customer_id,
        SUM (IF(m.product_name = 'sushi', (menu.price * 2) * 10, menu.price * 10)) AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;
```
<img width="185" alt="case1 op9" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/53de75e5-ce94-4880-9829-991dd0ac0784">


***
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customers A and B have at the end of January?

```sql
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
```
<img width="227" alt="case1 op10" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/38fb2288-0317-4aea-876f-58cd00f83ad0">

***
## Bonus Questions
Generate some basic datasets so Danny's team can easily inspect the data without needing to use SQL.

**1. Join All The Things:** Generate a table with customer_id, order_date, product_name, price, member (Y/N)
```sql
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
```
<img width="431" alt="case1 op11" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/c6ea0706-a27b-4379-98c4-0524f184f4f8">

***
**2. Rank All The Things:** Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases. Hence, he expects null ranking values for the records when customers are not yet part of the loyalty program.

```sql
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
```
<img width="496" alt="case1 op12" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/5fd6d520-7990-4838-852c-1420e01171c0">

***
Let's connect on [LinkedIn!](https://www.linkedin.com/in/khushi-sabarad/)🤝
