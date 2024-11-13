# Case Study #3 - Foodie Fi
## A. Customer Journey

Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

```sql
SELECT   s.customer_id,
         p.plan_id,
         p.plan_name,
         s.start_date
FROM     foodie_fi.subscriptions s
JOIN     foodie_fi.plans p USING(plan_id)
JOIN     (SELECT DISTINCT customer_id
		 FROM foodie_fi.subscriptions
		 ORDER BY customer_id ASC
		 LIMIT 8) AS sample_customers
          ON s.customer_id = sample_customers.customer_id
ORDER BY s.customer_id, s.start_date;
```
| customer_id | plan_id | plan_name     | start_date |
| ----------- | ------- | ------------- | ---------- |
| 1  | 0  | trial            | 2020-08-01          |
| 1  | 1  | basic monthly   | 2020-08-08          |
| 2  | 0  | trial            | 2020-09-20          |
| 2  | 3  | pro annual       | 2020-09-27          |
| 3  | 0  | trial            | 2020-01-13          |
| 3  | 1  | basic monthly   | 2020-01-20          |
| 4  | 0  | trial            | 2020-01-17          |
| 4  | 1  | basic monthly   | 2020-01-24          |
| 4  | 4  | churn             | 2020-04-21          |
| 5  | 0  | trial            | 2020-08-03          |
| 5  | 1  | basic monthly   | 2020-08-10          |
| 6  | 0  | trial            | 2020-12-23          |
| 6  | 1  | basic monthly   | 2020-12-30          |
| 6  | 4  | churn             | 2021-02-26          |
| 7  | 0  | trial            | 2020-02-05          |
| 7  | 1  | basic monthly   | 2020-02-12          |
| 7  | 2  | pro monthly       | 2020-05-22          |
| 8  | 0  | trial            | 2020-06-11          |
| 8  | 1  | basic monthly   | 2020-06-18          |
| 8  | 2  | pro monthly       | 2020-08-03          |

***
Based on the sample data, here’s a brief onboarding journey for each of the 8 customers:

Customer 1: Moved to basic monthly plan after their free trial ended.

Customer 2: Upgraded to pro annual after the trial.

Customer 3: Moved to basic monthly plan after their free trial ended.

Customer 4: Moved to basic monthly plan after their free trial ended, and churned after about 3 months.

Customer 5: Moved to basic monthly plan after their free trial ended.

Customer 6: Moved to basic monthly plan after their free trial ended, and churned after about 2 months.

Customer 7: Moved to basic monthly plan after their free trial ended, and later chose pro monthly after 3+ months

Customer 8: Moved to basic monthly plan after their free trial ended, and later opted for pro monthly after 1.5 months.

Each customer followed a unique onboarding path, starting with a trial and exploring various plans, with some eventually upgrading to more advanced plans or choosing to churn.
