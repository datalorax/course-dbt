-- fact_products

{{ config(materialized = 'table') }}

WITH

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
)

, order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
)

, products AS (
    SELECT * FROM {{ ref('stg_products') }}
)

SELECT
  orders.order_id
  , orders.user_id
  , products.product_id
  , name AS product_name
  , orders.created_at
  , quantity
  , price
  , inventory AS total_inventory
FROM orders
LEFT JOIN order_items ON orders.order_id = order_items.order_id
LEFT JOIN products ON order_items.product_id = products.product_id
