{{
  config(
    materialized='incremental',
    unique_key = 'order_id'
  )
}}


WITH src_orders AS (
    SELECT * ,case when promo_id ='' then 'desconocida' else promo_id end as promo_id2
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

base_orders AS (
    SELECT
          {{dbt_utils.generate_surrogate_key(['order_id'])}} as order_id,
          case when shipping_service='' then 'ninguna' else  shipping_service end as shipping_service,
          cast(shipping_cost as float) as shipping_cost,
          {{dbt_utils.generate_surrogate_key(['address_id'])}} as address_id,
          CONVERT_TIMEZONE('UTC',created_at) as created_at,
          {{dbt_utils.generate_surrogate_key(['promo_id2'])}} as promo_id,
          CONVERT_TIMEZONE('UTC',estimated_delivery_at) as estimated_delivery_at,
          ROUND(cast(order_cost as float),2) as order_cost,
          {{dbt_utils.generate_surrogate_key(['user_id'])}} as user_id,
          ROUND(cast(order_total as float),2) as order_total,
          CONVERT_TIMEZONE('UTC',delivered_at) as delivered_at,
          cast(tracking_id as varchar) tracking_id,
          cast(status as varchar) status,
          _fivetran_deleted,
          CONVERT_TIMEZONE('UTC',_fivetran_synced) as _fivetran_synced
    FROM src_orders
    )

SELECT *
FROM 
base_orders
{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}