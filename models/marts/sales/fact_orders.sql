{{
  config(
    materialized='table',
    unique_key='order_item_id'
  )
}}

WITH orders AS(
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
    {% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}
),
order_items as (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
    {% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}
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
    DATEDIFF(day, estimated_delivery_at, delivered_at) as delay_days, -- días de retraso de llegada del envío
    DATEDIFF(day, created_at, delivered_at) as delivery_time_days, --tiempo que tarda en llegar el envío
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
    max(number) as numero_order -- número de distintos productos que tiene el pedido
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
    round(shipping_cost/numero_order,2) as shipping_cost, -- se divide shippin_cost para distribuir el coste de envio entre los distintos productos
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

SELECT *,
round((quantity*price)+shipping_cost-discount_euros,2) as total_order -- cálculo del coste total de cada grano de order_item
FROM FACT_ORDER





