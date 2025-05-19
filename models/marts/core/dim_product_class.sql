{{
  config(
    materialized='table'
  )
}}

WITH src_product_class AS (
    SELECT * 
    FROM {{ ref('stg_data_product_class') }}
    ),
src_product AS(
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
),
src_order_items AS(
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
),
product_class as(
    select 
    sp.class_id,
    count(distinct so.order_id) as n_order,
    round(sum(price),2) as total_order
    from
    src_product sp
    left join src_order_items so on sp.product_id=so.product_id
    group by 
    sp.class_id
)

select 
spc.class_id, 
spc.class,
n_order,
total_order 
from 
src_product_class spc
left join product_class pc 
on spc.class_id=pc.class_id


