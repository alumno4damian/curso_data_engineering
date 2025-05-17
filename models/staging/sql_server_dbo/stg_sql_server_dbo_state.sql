{{
  config(
    materialized='view'
  )
}}

WITH src_state AS (
    SELECT distinct state
    FROM {{ ref('base_sql_server_dbo_addresses') }}
    ),

stg_st AS (
    SELECT
    {{dbt_utils.generate_surrogate_key(['state'])}} as state_id,
    state
    FROM src_state
)
    
SELECT * FROM stg_st
order by state