{{
  config(
    materialized='table'
  )
}}

WITH src_city AS (
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
city as (
    select sc.*,
    count(order_id) as n_order,
    round(sum(order_total),2) as sum_order_total
    FROM 
    src_city sc
    left join src_add sa on sc.city_id=sa.city_id
    left join src_order so on sa.address_id=so.address_id
    group by 
    sc.city_id,
    city,
    population,
    density,
    state_id
    )
select * from city
