{{ config(materialized = 'table') }}

WITH

dim_users AS (
    SELECT * FROM {{ ref('dim_users') }}
)

, fact_events AS (
    SELECT * FROM {{ ref('fact_events') }}
)

, packages_shipped AS (
  SELECT user_id, event_count AS packages_shipped
  FROM fact_events
  WHERE event_type = 'package_shipped'
)

, page_views AS (
  SELECT user_id, event_count AS pages_viewed
  FROM fact_events
  WHERE event_type = 'page_view'
)

, added_to_cart AS (
  SELECT user_id, event_count AS added_to_cart
  FROM fact_events
  WHERE event_type = 'add_to_cart'
)

, checkouts AS (
  SELECT user_id, event_count AS checkouts
  FROM fact_events
  WHERE event_type = 'checkout'
)

SELECT 
 dim_users.*
, packages_shipped
, pages_viewed
, added_to_cart
, checkouts
FROM dim_users 
LEFT JOIN packages_shipped ON dim_users.user_id = packages_shipped.user_id
LEFT JOIN page_views ON dim_users.user_id = page_views.user_id
LEFT JOIN added_to_cart ON dim_users.user_id = added_to_cart.user_id
LEFT JOIN checkouts ON dim_users.user_id = checkouts.user_id