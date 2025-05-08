{{
  config(
    materialized='table'
  )
}}

WITH src_empresa_envio AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_orders') }}
    ),

base_empresa_envio AS (
    SELECT
          distinct shipping_service
    )

SELECT * FROM base_empresa_envio