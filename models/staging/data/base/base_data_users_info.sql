{{
  config(
    materialized='view'
  )
}}

WITH src_user AS (
    SELECT * 
    FROM {{ source('data', 'users_info') }}
    ),

base_user AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['user_id'])}} as user_id,
        cast(sex as varchar(1)) sex,
        TO_DATE(birthdate, 'DD/MM/YYYY') AS birthdate,
        cast(pet as BOOLEAN) pet
    FROM src_user
    )
    
SELECT * FROM base_user