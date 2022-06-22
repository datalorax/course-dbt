{{ config(materialized = 'table') }}

WITH

fact_orders AS (
  SELECT * FROM {{ ref('fact_orders') }}
)

SELECT
  promo_id
  , {{ dbt_utils.pivot(
      'state_shipped_to',
      dbt_utils.get_column_values(ref('fact_orders'), 'state_shipped_to')
    ) }}
FROM fact_orders
GROUP BY 1
HAVING promo_id IS NOT NULL
