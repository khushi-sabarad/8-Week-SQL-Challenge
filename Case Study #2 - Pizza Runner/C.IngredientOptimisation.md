# 🍕 Case Study #2 - Pizza Runner

## C. Ingredient Optimisation

What are the standard ingredients for each pizza?
```sql
SELECT
	pr.pizza_id,
	pn.pizza_name,
	pr.toppings
FROM
	pizza_recipes pr
JOIN pizza_names pn ON pr.pizza_id = pn.pizza_id;
```
| pizza_id | pizza_name   | toppings                | 
| -------- | ------------ |------------------------ |
| 1        | Meatlovers   | 1, 2, 3, 4, 5, 6, 8, 10 |
| 2        | Vegetarian   | 4, 6, 7, 9, 11, 12      |

***

What was the most commonly added extra?
```sql
SELECT extras,
    COUNT(extras) AS count_extras
FROM customer_orders
WHERE extras LIKE '%'
GROUP BY extras;
```
| extras | count_extras   |
| ------ | -------------- |
| 1, 5   | 1              |
| 1, 4   | 1              |
***

What was the most common exclusion?
```sql

```

***
Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

```sql

```

***

Generate an alphabetically ordered comma-separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients.

For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
```sql

```

***

What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
```sql

```

***
