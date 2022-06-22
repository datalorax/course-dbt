{{ config(materialized = 'table') }}

WITH

events AS (
  SELECT * FROM {{ ref('stg_events') }}
)

, products AS (
  SELECT * FROM {{ ref('stg_products') }}
)

SELECT 
  events.*,
  products.name
FROM events
LEFT JOIN products ON events.product_id = products.product_id
