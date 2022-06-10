# Project 1 Answers
> How many users do we have?

**Code**: 
```sql
SELECT 
  COUNT(DISTINCT user_id) AS n_users
FROM 
  dbt_daniel_a.stg_users
```
**Answer**: 130

---

> On average, how many orders do we receive per hour?

**Code**:
```sql
WITH

total_orders_per_hour AS (
  SELECT 
    EXTRACT(HOUR FROM created_at) AS hour
    , COUNT(*) as n_orders
  FROM 
    dbt_daniel_a.stg_orders
  GROUP BY 1
  ORDER BY 1
)

SELECT
  AVG(n_orders) AS mean_orders_per_hour
FROM total_orders_per_hour
```

**Answer**: 15.04

---

> On average, how long does an order take from being placed to being delivered?

**Code**:
```sql
SELECT 
  AVG(delivered_at - created_at) as time_to_delivery
FROM dbt_daniel_a.stg_orders
```
**Answer**
3 days 21:24:11.803279

> How many users have only made one purchase? Two purchases? Three+ purchases?
Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

**Code**:
```sql
WITH

orders_per_user AS (
  SELECT 
    user_id
    , COUNT(*) AS n_orders
  FROM dbt_daniel_a.stg_orders
  GROUP BY user_id
)

SELECT
  n_orders
  , COUNT(*) AS frequency
FROM orders_per_user
GROUP BY n_orders
ORDER BY n_orders
```
**Answer**:
|n_orders| frequency|
|:-------|:---------|
| 1 | 25|
| 2 | 28|
| 3 | 34|
| 4 | 20|
| 5 | 10|
| 6 | 2|
| 7 | 4|
| 8 | 1|

> On average, how many unique sessions do we have per hour?

**Code**:
```sql
WITH

sessions_by_hour AS (
  SELECT 
    EXTRACT(HOUR FROM created_at) AS hour
    , COUNT(DISTINCT session_id) AS n_sessions
  FROM dbt_daniel_a.stg_events
  GROUP BY hour
)

SELECT 
  AVG(n_sessions) AS mean_unique_sessions
FROM sessions_by_hour
```

**Answer**:
39.4583333333333333
