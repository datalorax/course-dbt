{{ config(materialized = 'table') }}

WITH

int_products AS (
  SELECT * FROM {{ ref('int_products') }}
)

, add_null_count AS (
  SELECT
    *
    , CASE
        WHEN order_id IS NULL 
        THEN 0
        ELSE 1
      END AS is_null_order_id
  FROM int_products
)

, session_start AS (
  SELECT
    session_id
    , MIN(created_at) AS session_start
  FROM int_products
  GROUP BY session_id
)

, session_start_timestamped AS (
  SELECT
    session_id
    , DATE_PART('year', session_start) AS session_start_year
    , DATE_PART('month', session_start) AS session_start_month
    , DATE_PART('day', session_start) AS session_start_day
    , DATE_PART('hour', session_start) AS session_start_hour
  FROM session_start 
)

, orders_placed AS (
  SELECT 
    session_id
    , CASE
        WHEN SUM(is_null_order_id) > 0
        THEN 1
        ELSE 0
      END AS order_placed
  FROM add_null_count
  GROUP BY session_id
)

SELECT
  orders_placed.session_id
  , session_start_year
  , session_start_month
  , session_start_day
  , session_start_hour
  , name
  , event_type
  , order_placed
FROM int_products
LEFT JOIN orders_placed ON int_products.session_id = orders_placed.session_id
LEFT JOIN session_start_timestamped ON orders_placed.session_id = session_start_timestamped.session_id