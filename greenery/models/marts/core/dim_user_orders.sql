-- dim_user_orders

{{ config(materialized = 'table') }}

WITH

users AS (
    SELECT * FROM {{ ref('stg_users') }}
)

, orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
)

, order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
)

SELECT
  users.user_id
  , orders.order_id
  , users.address_id
  , first_name
  , last_name
  , email
  , phone_number
  , orders.created_at AS order_datetime
  , quantity
  , name
  , price
  , promos.promo_id AS promo_id
  , discount AS promo_discount
  , price * quantity AS subtotal_cost
  , order_cost AS total_order_cost
FROM users
LEFT JOIN orders ON users.user_id = orders.user_id
LEFT JOIN promos ON orders.promo_id = promos.promo_id
LEFT JOIN order_items ON orders.order_id = order_items.order_id
LEFT JOIN products ON order_items.product_id = products.product_id
ORDER BY user_id, order_id -- not neccessary but nicer for viewing