-- dim_users

{{ config(materialized = 'table') }}

WITH

users AS (
    SELECT * FROM {{ ref('stg_users') }}
)

, addresses AS (
    SELECT * FROM {{ ref('stg_addresses') }}
)

SELECT
  user_id
  , users.address_id
  , first_name
  , last_name
  , email
  , phone_number
  , address
  , zipcode
  , state
  , country
FROM users
LEFT JOIN addresses ON users.address_id = addresses.address_id
