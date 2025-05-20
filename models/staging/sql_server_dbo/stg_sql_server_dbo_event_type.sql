{{
  config(
    materialized='view'
  )
}}


WITH src_events AS (
    SELECT distinct event_type
    FROM {{ source('sql_server_dbo', 'events') }}
    ),
event_type as (
    SELECT
    {{dbt_utils.generate_surrogate_key(['event_type'])}} as event_type_id,
    event_type
    FROM src_events
    )
select * from event_type
order by event_type