{{
  config(
    materialized='table'
  )
}}

WITH src_promos AS(
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_promos') }}
),
orders as (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),
promos as(
    SELECT 
    sp.promo_id,
    promo_desc,
    sp.status,
    count(order_id) as n_oorder,
    sum(discount_euros) as total_discount
    FROM
    src_promos sp 
    left join orders o 
    on sp.promo_id=o.promo_id
    group by
    sp.promo_id,
    promo_desc,
    sp.status
)

select * from promos