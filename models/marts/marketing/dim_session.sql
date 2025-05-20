{{
  config(
    materialized='table'
  )
}}

WITH  events as (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_events' )}}
),
dim_session as (
    select 
    session_id,
    count(event_id) as n_event,
    min(created_at) as session_start,
    max(created_at) as session_end,
    datediff(min, min(created_at), max(created_at)) as session_duration_min,
    max(user_id) as user_id,
    count(distinct producto_id) as n_product_view,
    max(order_id) as order_id
    from
    events
    group  by session_id
)

select 
session_id,
n_event,
session_start,
session_end,
session_duration_min,
user_id,
n_product_view,
case when order_id is null or order_id='' then 'No' else 'Yes' end as session_with_order
from dim_session


