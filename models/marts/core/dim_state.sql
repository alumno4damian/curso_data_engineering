{{
  config(
    materialized='table'
  )
}}

WITH src_state AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_state') }}
    ),
src_city AS (
    SELECT * 
    FROM {{ ref('stg_data_cities') }}
    ),
src_order AS(
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_orders') }}
    ),
src_add AS(
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_address') }}
    ),
state as (
    select ss.*,
    count(order_id) as n_order,
    round(sum(order_total),2) as sum_order_total
    FROM 
    src_state ss
    left join src_city sc on ss.state_id=sc.state_id
    left join src_add sa on sc.city_id=sa.city_id
    left join src_order so on sa.address_id=so.address_id
    group by 
    ss.state_id,
    state,
    country
    )
select * from state
