
{{ config(materialized = 'table') }}

WITH

fact_products AS (
    SELECT * FROM {{ ref('fact_products') }}
)

, purchases AS (
  SELECT
    product_id
    , product_name
    -- This subquery to select the max `created_at` is a placeholder for `now()`, which I would use with a live database
    , DATE_PART('Day', (SELECT MAX(created_at) FROM orders) - created_at) AS days_since_order
    , SUM(quantity) AS orders_in_last_day
  FROM fact_products
  GROUP BY 1, 2, 3
  HAVING DATE_PART('Day', (SELECT MAX(created_at) FROM orders) - created_at) < 1
)

, inventory AS (
  SELECT 
    DISTINCT product_id
    , total_inventory
  FROM fact_products
)

SELECT
  purchases.product_id
  , product_name
  , orders_in_last_day
  , total_inventory
FROM purchases
LEFT JOIN inventory ON purchases.product_id = inventory.product_id