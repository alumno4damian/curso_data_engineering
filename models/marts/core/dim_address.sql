{{
  config(
    materialized='table'
  )
}}

WITH src_add AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_address') }}
    ),
src_order AS(
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_orders') }}
    ),
src_order_items AS(
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
    ),
address_item AS(
    SELECT address_id, 
    product_id, 
    sum(quantity) as total_quantity,
    ROW_NUMBER() OVER (PARTITION BY so.address_id ORDER BY SUM(si.quantity) DESC) AS rn
    FROM 
    src_order so
    inner join src_order_items si on so.order_id=si.order_id
    group by address_id, product_id
),
address_modeitem AS(
    SELECT address_id, product_id
    FROM 
    address_item
    where rn=1 
),
dim_add AS (
    SELECT
        sa.address_id,
        address,
        city_id,
        count(so.order_id) as n_order,
        sum(so.order_total) as order_total,
    FROM src_add sa
    LEFT JOIN src_order so on sa.address_id=so.address_id
    group by 
        sa.address_id,
        address,
        city_id
    ),
dim_address as (
    SELECT da.*, am.product_id as mode_product_id
    FROM 
    dim_add da inner join address_modeitem am
    on da.address_id=am.address_id
)

 SELECT *
 FROM  dim_address