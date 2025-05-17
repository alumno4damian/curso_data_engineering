{{
  config(
    materialized='view'
  )
}}

WITH src_prod AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_products') }}
    ),

stg_prod AS (
    SELECT
    product_id,
    name,
    status,
    _fivetran_deleted,
    _fivetran_synced
    FROM src_prod
)
    
SELECT * FROM stg_prod