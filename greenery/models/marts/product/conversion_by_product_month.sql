{{ config(materialized = 'table') }}

WITH

fact_session_orders AS (
    SELECT * FROM {{ ref('fact_session_orders') }}
)

, product_views AS (
  SELECT 
    name
    , session_start_year
    , session_start_month
    , COUNT(*) AS views_n
  FROM fact_session_orders
  WHERE event_type = 'page_view'
  GROUP BY 
    name
    , session_start_year
    , session_start_month
)

, product_purchased AS (
  SELECT 
    name
    , session_start_year
    , session_start_month
    , COUNT(*) AS purchases_n
  FROM fact_session_orders
  WHERE event_type = 'add_to_cart' AND order_placed = 1
  GROUP BY 
    name
    , session_start_year
    , session_start_month
)

SELECT
  product_views.name
  , product_views.session_start_year
  , product_views.session_start_month
  , views_n
  , purchases_n
  , {{ compute_conversion('purchases_n', 'views_n') }} AS conversion_rate
FROM product_views
LEFT JOIN product_purchased ON product_views.name = product_purchased.name