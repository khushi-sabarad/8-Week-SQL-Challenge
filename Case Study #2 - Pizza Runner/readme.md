# Case Study #2 - Pizza Runner 🍕
<img src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/dc2eb556-ac0c-49a7-8e2b-57853348ba41" alt="Image" width="500" height="480">

 ***

## Introduction
Danny was scrolling through his Instagram feed when something caught his eye - “80s Retro Styling and Pizza Is The Future!”
Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!
Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (or Danny’s house) and maxed out his credit card to pay freelance developers to build a mobile app to accept customer orders.

## Problem Statement
Because Danny had a few years of experience as a data scientist, he knew that data collection would be critical for his business’ growth.
He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.
All datasets exist within the pizza_runner database schema.

**`ERD(Entity Relationship Diagram)`** :

<img width="600" alt="case2 ERD" src="https://github.com/khushi-sabarad/8-Week-SQL-Challenge/assets/71957748/7fc39133-f4b2-4eb0-b524-26c160dd03be">

[Click here](https://8weeksqlchallenge.com/case-study-2/) to learn more about the case study in detail.

***
(Tool used: MYSQL 8.0 Command Line Client) 

## Data Cleaning
Table: customer_orders

We have to clean the 'exclusions' and the 'extras' columns.

- There are comma-separated values. It is a common practice to store these values in separate rows but as each row represents an individual pizza in this case, I am leaving them just the way they are.

- ‘null’, empty string values.
we could create temp tables to make these changes but as the changes to be made are not major, I'm not creating a db copy or temp tables.

```sql
UPDATE customer_orders
SET exclusions = NULL, extras = NULL
WHERE exclusions = '' OR exclusions = 'null' OR extras = '' OR extras = 'null';
```

***
Table: runner_orders

```sql
-- 1. Check the null/empty values
UPDATE runner_orders
SET pickup_time = NULLIF(pickup_time, 'null'),
    distance = NULLIF(distance, 'null'),
    duration = NULLIF(duration, 'null'),
    cancellation = NULLIF(NULLIF(NULLIF(cancellation, ''), 'NaN'), 'null');

-- 2. Remove alphabets from duration and distance columns using REGEXP_REPLACE
UPDATE runner_orders
SET duration = REGEXP_REPLACE(duration, '[^0-9.]', ''),
    distance = REGEXP_REPLACE(distance, '[^0-9.]', '');

-- 3. Rename columns (add the units) and change data types
ALTER TABLE runner_orders
CHANGE COLUMN duration duration_mins FLOAT,
CHANGE COLUMN distance distance_km FLOAT;

-- 4. Change the data type of the pickup_time column to TIMESTAMP
ALTER TABLE runner_orders
MODIFY COLUMN pickup_time TIMESTAMP;

describe runner_orders;
```
***
Case Study Questions are broken up by area of focus including:

A. [Pizza Metrics](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/A.PizzaMetrics.md)

B. [Runner and Customer Experience](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/B.RunnerAndCustomerExperience.md)

C. [Ingredient Optimisation](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/C.IngredientOptimisation.md)

D. [Pricing and Ratings](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/D.PricingAndRatings.md)

E. [Bonus DML Challenges (DML = Data Manipulation Language)](https://github.com/khushi-sabarad/8-Week-SQL-Challenge/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/E.BonusQuestions.md)

***
Let's connect on [LinkedIn!](https://www.linkedin.com/in/khushi-sabarad/)🤝
