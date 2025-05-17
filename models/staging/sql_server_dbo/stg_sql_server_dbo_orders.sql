{{
  config(
    materialized='view'
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_orders') }}
    ),
src_prom AS(
    SELECT *
    FROM {{ ref('base_sql_server_dbo_promos') }}
),
stg_orders AS (
    SELECT
    order_id, 
    {{dbt_utils.generate_surrogate_key(['shipping_service'])}} as shipping_service_id,
    shipping_cost,
    created_at,
    sp.promo_id,
    sp.discount_euros,
    estimated_delivery_at,
    delivered_at,
    user_id,
    order_cost,
    order_total,
    tracking_id,
    so.status,
    so._fivetran_deleted,
    so._fivetran_synced
    FROM src_orders so  
    LEFT JOIN src_prom sp ON so.promo_id=sp.promo_id
)
    
SELECT * FROM stg_orders