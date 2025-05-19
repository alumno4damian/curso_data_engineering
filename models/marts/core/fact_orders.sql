{{
  config(
    materialized='table'
  )
}}

WITH orders AS(
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),
order_items as (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
),

orders2 as(
    SELECT 
    order_item_id,
    o.order_id,
    oi.product_id,
    quantity,
    price,
    shipping_service_id,
    shipping_cost,
    address_id,
    created_at,
    promo_id,
    discount_euros,
    estimated_delivery_at,
    delivered_at,
    DATEDIFF(day, estimated_delivery_at, delivered_at) as delay_days,
    DATEDIFF(day, created_at, delivered_at) as delivery_time_days,
    user_id,
    tracking_id,
    status,
    ROW_NUMBER() OVER(PARTITION BY o.order_id order by product_id) as number
    FROM
    orders o 
    left join order_items oi
    on o.order_id=oi.order_id
),
row_order as(
    select 
    order_id,
    max(number) as numero_order
    from 
    orders2
    group by order_id
),
fact_order as (
    SELECT 
    order_item_id,
    o.order_id,
    product_id,
    quantity,
    price,
    shipping_service_id,
    round(shipping_cost/numero_order,2) as shipping_cost,
    address_id,
    created_at,
    promo_id,
    round(discount_euros/numero_order,2) as discount_euros,
    estimated_delivery_at,
    delivered_at,
    delay_days,
    delivery_time_days,
    user_id,
    tracking_id,
    status
    from 
    orders2 o 
    left join row_order ro
    on o.order_id=ro.order_id
)

SELECT * 
FROM FACT_ORDER



