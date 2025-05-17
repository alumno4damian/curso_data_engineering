{{
  config(
    materialized='view'
  )
}}

WITH src_cities AS (
    SELECT * 
    FROM {{ ref('base_data_cities') }}
    ),
src_add AS (
    SELECT *
    FROM {{ ref('base_sql_server_dbo_addresses') }}
    ),
stg_cities AS (
    SELECT
    sc.zipcode as city_id,
    city,
    population,
    density,
    {{dbt_utils.generate_surrogate_key(['state'])}} as state_id,
    country
    FROM src_cities sc 
    LEFT JOIN src_add sa ON sc.zipcode=sa.zipcode
    )
    
SELECT * FROM stg_cities