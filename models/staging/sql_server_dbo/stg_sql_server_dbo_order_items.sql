{{
  config(
    materialized='incremental',
    unique_key= 'order_item_id'
  )
}}

WITH src_or AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_order_items') }}
    ),
src_prod AS(
    SELECT *
    FROM {{ ref('base_sql_server_dbo_products') }}
),
stg_or AS (
    SELECT
   order_item_id,
   order_id,
   so.product_id,
   quantity,
   price,
   so._fivetran_synced,
   so._fivetran_deleted
    FROM src_or so  
    LEFT JOIN src_prod sp ON so.product_id=sp.product_id
)
    
SELECT * FROM stg_or
{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}