{{
  config(
    materialized='table'
  )
}}

WITH 

products AS(
  SELECT *
  FROM {{ source('greenery', 'products') }}
)

SELECT
  product_id
  , name
  , price
  , inventory
FROM products