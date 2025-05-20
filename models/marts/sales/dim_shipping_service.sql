{{
  config(
    materialized='table'
  )
}}

WITH src_ss AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_shipping_service') }}
    ),
src_order AS(
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_orders') }}
    ),
shipping_service AS (
    select 
    ss.shipping_service_id,
    ss.shipping_service,
    sum(shipping_cost) as total_shipping_cost,
    round(AVG(shipping_cost),2) as avg_shipping_cost,
    round(AVG(DATEDIFF(day,estimated_delivery_at, delivered_at)),2) as avg_delay_days,
    round(AVG(DATEDIFF(day,created_at, delivered_at)),2) as delivery_time_days,
    count(order_id) as n_order
    FROM 
    src_ss ss
    LEFT JOIN src_order so on ss.shipping_service_id=so.shipping_service_id
    GROUP BY
    ss.shipping_service_id,
    ss.shipping_service
)
select * from shipping_service



