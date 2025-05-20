{{
  config(
    materialized='table'
  )
}}

WITH src_product_class AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_event_type') }}
    ),
events as (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_events' )}}
),
dim_event_type as (
    select 
    sc.event_type_id,
    sc.event_type,
    count(distinct event_id) as n_events
    from 
    src_product_class  sc 
    left join events e
    on sc.event_type_id=e.event_type_id
    group by  sc.event_type_id,
    sc.event_type
)
select * from dim_event_type