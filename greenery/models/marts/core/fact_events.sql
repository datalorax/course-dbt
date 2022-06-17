
{{ config(materialized = 'table') }}

WITH

events AS (
    SELECT * FROM {{ ref('stg_events') }}
)

, time_spent AS (
  SELECT
    user_id
    , MAX(created_at) - MIN(created_at) AS total_time_on_website
  FROM events
  GROUP BY user_id
)

, event_counts AS (
  SELECT
    user_id
    , event_type
    , count(*) AS event_count
  FROM dbt.dbt_daniel_a.stg_events
  GROUP BY user_id, event_type
)

SELECT
  time_spent.user_id
  , total_time_on_website
  , event_type
  , event_count
FROM time_spent
LEFT JOIN event_counts ON time_spent.user_id = event_counts.user_id
