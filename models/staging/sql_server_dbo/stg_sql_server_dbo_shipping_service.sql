{{
  config(
    materialized='table'
  )
}}

WITH src_empresa_envio AS (
    SELECT distinct shipping_service
    FROM {{ ref('base_sql_server_dbo_orders') }}
    ),

base_empresa_envio AS (
    SELECT
    {{dbt_utils.generate_surrogate_key(['shipping_service'])}} as shipping_service_id,
    shipping_service  
    FROM
    src_empresa_envio
    )

SELECT * FROM base_empresa_envio
order by shipping_service