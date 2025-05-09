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
          cast(price as float) as precio,
          name as desc_producto,
          cast(inventory as int) as inventario,
          _fivetran_deleted,
          CONVERT_TIMEZONE('UTC',_fivetran_synced) as _fivetran_synced
    FROM src_products
    )

SELECT * FROM base_products