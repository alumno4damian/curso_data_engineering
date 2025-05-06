{{
  config(
    materialized='view'
  )
}}

WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

base_products AS (
    SELECT
          {{dbt_utils.generate_surrogate_key(['product_id'])}} as product_id,
          product_id as product,
          price as precio,
          name as desc_producto,
          inventory as inventario,
          _fivetran_deleted,
          _fivetran_synced
    FROM src_products
    )

SELECT * FROM base_products