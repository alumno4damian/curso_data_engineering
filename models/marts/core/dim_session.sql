{{
  config(
    materialized='table'
  )
}}

WITH  events as (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_events' )}}
)

select 
session_id,
count(event_id) as n_event
from
events
group  by session_id