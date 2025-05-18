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
    )

 SELECT *
 FROM  dim_add