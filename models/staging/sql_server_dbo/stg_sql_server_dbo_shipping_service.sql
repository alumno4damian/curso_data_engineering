{{
  config(
    materialized='view'
  )
}}

WITH src_ss AS (
    SELECT distinct shipping_service
    FROM {{ ref('base_sql_server_dbo_orders') }}
    ),

stg_ss AS (
    SELECT
    {{dbt_utils.generate_surrogate_key(['shipping_service'])}} as shipping_service_id,
    shipping_service
    FROM src_ss
)
    
SELECT * FROM stg_ss
order by shipping_service