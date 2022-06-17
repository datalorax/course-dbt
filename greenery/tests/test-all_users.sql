-- Asserts that all users in fact_users are represented in dim_users
-- and that no users are in one table but not the other

{{
    config(
        severity='warn'
    )
}}

WITH

stg_users AS (
    SELECT * FROM {{ ref('stg_users') }}
)

, dim_users AS (
    SELECT * FROM {{ ref('dim_users') }}
)


SELECT 
  stg_users.user_id AS stg_users_user_id
  , dim_users.user_id AS dim_users_user_id
FROM 
  stg_users
NATURAL FULL OUTER JOIN
  dim_users
WHERE stg_users.user_id <> dim_users.user_id


SELECT student_id
FROM {{ ref('fct_course_requests_for_scheduling_by_subject') }}
GROUP BY student_id, transcript_subject_category, schedule_id
HAVING COUNT(student_id) > 1
