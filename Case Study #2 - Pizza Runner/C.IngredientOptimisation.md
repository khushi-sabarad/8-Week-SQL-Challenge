# 🍕 Case Study #2 - Pizza Runner
## C. Ingredient Optimisation

(Tool used: MYSQL Workbench & Google Collab) 

## Data Cleaning
Table: pizza_recipes
|  pizza_id   | toppings                |
| ----------- | ------------------------|
| 1           | 1, 2, 3, 4, 5, 6, 8, 10 |
| 2           | 4, 6, 7, 9, 11, 12      |

contains comma-separated values within the toppings column. 

I found it too complicated to separate the values using MySQL, so I used Python in Google Collab instead.
- export the pizza_recipes table
- import the same in Collab
  
```python
import numpy as np
import pandas as pd

pizza = pd.read_csv('/content/pizza_recipes.csv')
pizza

x = pizza.assign(toppings=pizza['toppings'].str.split(','))
x

# explode method to separate each pair into separate rows
x_clean = x.explode('toppings')
x_clean

x_clean.to_csv('pizza_recipes_cleaned.csv')

```
- download the csv file
- import it in MySQL workbench, under the pizza_runner schema

table: pizza_recipes_cleaned
| pizza_id | toppings |
| ---------| -------- |
| 1        | 1        |
| 1        | 2        |
| 1        | 3        |
| 1        | 4        |
| 1        | 5        |
| 1        | 6        |
| 1        | 8        |
| 1        | 10       |
| 2        | 4        |
| 2        | 6        |
| 2        | 7        |
| 2        | 9        |
| 2        | 11       |
| 2        | 12       |

***


1. What are the standard ingredients for each pizza?
   
```sql
SELECT 
    prc.pizza_id, 
    pn.pizza_name, 
    GROUP_CONCAT(pt.topping_name) AS standard_ingredients
FROM pizza_recipes_cleaned prc
LEFT JOIN pizza_toppings pt ON prc.toppings = pt.topping_id
LEFT JOIN pizza_names pn ON prc.pizza_id = pn.pizza_id
GROUP BY prc.pizza_id, pn.pizza_name;
```

| pizza_id | pizza_name | standard_ingredients 						 |
| -------- | ---------- | -------------------------------------------------------------- |
| 1	   | Meatlovers	| Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami |
| 2	   | Vegetarian	| Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce          |


***

2. What was the most commonly added extra?
```sql
SELECT extras,
    COUNT(extras) AS num_times_added
FROM customer_orders
WHERE extras LIKE '%'
GROUP BY extras;
```
| extras | num_times_added |
| ------ | --------------- |
| 1, 5   | 1               |
| 1, 4   | 1               |

The most commonly added extra is Bacon whose topping_id is 1. It was added as an extra twice.

***

3. What was the most common exclusion?
```sql
SELECT exclusions,
    COUNT(exclusions) AS num_times_added
FROM customer_orders
WHERE exclusions LIKE '%'
GROUP BY exclusions;
```
| exclusions | num_times_added |
| ---------- | --------------- |
| 4          | 1               |
| 2, 6       | 1               |

(2) BBQ Sauce, (4) Cheese, and (6) Mushrooms: were all excluded from an order once.  

***
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
```sql
SELECT * FROM customer_orders
WHERE pizza_id = 1;
```
All customer_orders with pizza_id 1 (Meatlovers) is generated

- Meat Lovers - Exclude Beef
```sql
SELECT * FROM customer_orders
WHERE pizza_id = 1 AND exclusions LIKE '%3%';
```
Nothing is generated as it looks like all Meatlovers love Beef.

- Meat Lovers - Extra Bacon
```sql
SELECT * FROM customer_orders
WHERE pizza_id = 1 AND extras LIKE '%1%';
```
| order_id | customer_id | pizza_id | exclusions | extras | order_time          |
| -------- | ----------- | -------- | ---------- | ------ | ------------------- |
| 9	   | 103	 | 1	    | 4	         | 1, 5	  | 2020-01-10 11:22:59 |
| 10	   | 104	 | 1	    | 2, 6	 | 1, 4	  | 2020-01-11 18:34:49 |

Bacon's topping_id is 1 

- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
```sql
SELECT * FROM customer_orders
WHERE pizza_id = 1 AND exclusions LIKE '%4%' AND exclusions LIKE '%1%' AND extras LIKE '%6%' AND extras LIKE '%9%';
```
0 rows returned

***

5. Generate an alphabetically ordered comma-separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients.

For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
```sql

```

***

6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
```sql

```

***
