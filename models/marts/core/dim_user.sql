{{
  config(
    materialized='table'
  )
}}

WITH src_us AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_users') }}
    ),
src_order AS(
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_orders') }}
    ),
order_items AS(
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
    ),
dim_us AS (
    SELECT
        sa.address_id,
        first_name,
        last_name,
        updated_at,
        sa.created_at,
        sa.address_id,
        phone_number,
        email,
        sex,
        age,
        pet,
        count(so.order_id) as n_order,
        sum(so.order_total) as order_total,
        mode(oi.product_id)
    FROM src_us sa
    LEFT JOIN src_order so on sa.address_id=so.address_id
    left join order_items oi on so.order_id=oi.order_id
    group by 
                sa.address_id,
        first_name,
        last_name,
        updated_at,
        sa.created_at,
        sa.address_id,
        phone_number,
        email,
        sex,
        age,
        pet
    )

 SELECT *
 FROM  dim_us