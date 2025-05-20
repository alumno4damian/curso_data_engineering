{{
  config(
    materialized='incremental',
    unique_key='order_item_id'
  )
}}


WITH src_order_it AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
    ),

base_order_it AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['order_id','product_id'])}} as order_item_id,
        {{dbt_utils.generate_surrogate_key(['order_id'])}} order_id,
        {{dbt_utils.generate_surrogate_key(['product_id'])}} product_id,
        cast(quantity as integer) quantity,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC',_fivetran_synced) as _fivetran_synced
    FROM src_order_it
    )

SELECT * FROM base_order_it
{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}
