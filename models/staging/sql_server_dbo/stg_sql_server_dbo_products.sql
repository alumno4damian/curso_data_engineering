{{
  config(
    materialized='table'
  )
}}

WITH src_product AS (
    SELECT *
    FROM {{ ref('base_sql_server_dbo_products') }}
    ),

stg_products AS (
    SELECT
    product_id,
    desc_producto,
    inventario
FROM src_product
    )

SELECT * FROM stg_products
order by desc_producto