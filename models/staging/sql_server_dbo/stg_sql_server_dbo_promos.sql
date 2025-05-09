{{
  config(
    materialized='table'
  )
}}

WITH src_promos AS (
    SELECT *
    FROM {{ ref('base_sql_server_dbo_promos') }}
    ),

stg_promos AS (
    SELECT
    promo_id,
    desc_promo,
    descuento_euros,
    estado
FROM src_promos
    )

SELECT * FROM stg_products
order by desc_promos