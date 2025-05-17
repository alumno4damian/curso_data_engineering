{{
  config(
    materialized='view'
  )
}}


WITH src_order_it AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
    ),

base_order_it AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['order_id','product_id'])}} as order_item_id,
        {{dbt_utils.generate_surrogate_key(['order_id'])}} oder_id,
        {{dbt_utils.generate_surrogate_key(['product_id'])}} product_id,
        cast(quantity as integer) quantity,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC',_fivetran_synced) as _fivetran_synced
    FROM src_order_it
    )

SELECT * FROM base_order_it

