{{
  config(
    materialized='view'
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
          cast(shipping_cost as float) as coste_envio,
          CONVERT_TIMEZONE('UTC',created_at) as fecha_creacion,
          {{dbt_utils.generate_surrogate_key(['promo_id2'])}} as promo_id,
          CONVERT_TIMEZONE('UTC',estimated_delivery_at) as fecha_estimada_envio,
          cast(order_cost as float) as coste_pedido,
          {{dbt_utils.generate_surrogate_key(['user_id'])}} as user_id,
          cast(order_total as float) as coste_pedido_total,
          CONVERT_TIMEZONE('UTC',delivered_at) as fecha_envio,
          tracking_id,
          status as estado,
          _fivetran_deleted,
          CONVERT_TIMEZONE('UTC',_fivetran_synced) as _fivetran_synced
    FROM src_orders
    )

SELECT * FROM base_orders

