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
user_item AS(
    SELECT user_id, 
    product_id, 
    sum(quantity) as total_quantity,
    ROW_NUMBER() OVER (PARTITION BY so.user_id ORDER BY SUM(si.quantity) DESC) AS rn
    FROM 
    src_order so
    inner join order_items si on so.order_id=si.order_id
    group by user_id, product_id
),
user_modeitem AS(
    SELECT user_id, product_id
    FROM 
    user_item
    where rn=1 
),
dim_us AS (
    SELECT
        sa.user_id,
        first_name,
        last_name,
        sa.updated_at,
        sa.created_at,
        sa.address_id,
        phone_number,
        email,
        sex,
        age,
        pet,
        count(so.order_id) as n_order,
        round(sum(so.order_total),2) as order_total,
    FROM src_us sa
    LEFT JOIN src_order so on sa.user_id=so.user_id
    group by 
        sa.user_id,
        first_name,
        last_name,
        sa.updated_at,
        sa.created_at,
        sa.address_id,
        phone_number,
        email,
        sex,
        age,
        pet
    ),
dim_user AS(
    SELECT
    du.*, um.product_id as mode_product_id
    FROM
    dim_us du 
    LEFT JOIN user_modeitem um on du.user_id=um.user_id
)

 SELECT *
 FROM  dim_user