{{
  config(
    materialized='table'
  )
}}

WITH 

promos AS(
  SELECT *
  FROM {{ source('greenery', 'promos') }}
)

SELECT 
  promo_id
  , discount
  , status
FROM promos