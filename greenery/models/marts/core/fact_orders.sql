-- fact_orders

{{ config(materialized = 'table') }}

WITH

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
)

, promos AS (
    SELECT * FROM {{ ref('stg_promos') }}
)

, addresses AS (
    SELECT * FROM {{ ref('stg_addresses') }}
)

SELECT 
  orders.user_id
  , orders.order_id
  , addresses.address_id
  , address AS address_shipped_to
  , zipcode AS zipcode_shipped_to
  , state AS state_shipped_to
  , country AS country_shipped_to
  , tracking_id
  , shipping_service
  , estimated_delivery_at
  , delivered_at
  , orders.status AS shipping_status
  , shipping_cost
  , promos.promo_id
  , discount AS promo_discount
  , order_total
FROM orders
LEFT JOIN promos ON orders.promo_id = promos.promo_id
LEFT JOIN addresses ON orders.address_id = addresses.address_id
