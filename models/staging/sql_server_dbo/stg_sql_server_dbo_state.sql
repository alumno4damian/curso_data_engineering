{{
  config(
    materialized='view'
  )
}}

WITH src_state AS (
    SELECT distinct state, country
    FROM {{ ref('base_sql_server_dbo_addresses') }}
    ),

stg_st AS (
    SELECT
    {{dbt_utils.generate_surrogate_key(['state'])}} as state_id,
    state,
    country
    FROM src_state
)
    
SELECT * FROM stg_st
order by state