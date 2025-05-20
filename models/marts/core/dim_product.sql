{{
  config(
    materialized='table'
  )
}}

WITH src_product AS(
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
),
src_order_items AS(
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
),
src_orders AS(
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),
src_budget as(
    SELECT * 
    FROM {{ ref('stg_google_sheets_budget') }}
),
product as(
    select 
    sp.product_id,
    count(distinct so.order_id) as n_order,
    sum(quantity) as n_product_order,
    round(sum(price),2) as total_order
    from
    src_product sp
    left join src_order_items so on sp.product_id=so.product_id
    group by 
    sp.product_id
),
dim_product as(
    select 
    spc.product_id,
    name,
    inventory,
    class_id,
    flower,
    indoor,
    care_difficult,
    size,
    image_url,
    pc.n_order,
    n_product_order,
    pc.total_order
    from 
    src_product spc
    left join product pc 
    on spc.product_id=pc.product_id
)

select 
dp.*,
sb.quantity as budget,
case when dp.n_product_order>=sb.quantity then 1 else 0 end as cumplimiento_budget
from 
dim_product dp
left join src_budget sb 
on dp.product_id=sb.product_id and month(sb.date)=2


