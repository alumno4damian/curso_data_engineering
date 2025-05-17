{{
  config(
    materialized='view'
  )
}}


WITH src_events AS (
    SELECT *
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

events AS (
    SELECT
          {{dbt_utils.generate_surrogate_key(['event_id'])}} as event_id,
          cast(page_url as varchar) page_url,
          {{dbt_utils.generate_surrogate_key(['event_type'])}} as event_type_id,
          {{dbt_utils.generate_surrogate_key(['user_id'])}} as user_id,
          case when product_id='' then '' 
          else {{dbt_utils.generate_surrogate_key(['product_id'])}} 
          end as producto_id,
          cast(session_id as varchar) session_id,
          CONVERT_TIMEZONE('UTC',created_at) as created_at,
          case when order_id='' then '' 
          else {{dbt_utils.generate_surrogate_key(['order_id'])}} 
          end as order_id,
          _fivetran_deleted,
          CONVERT_TIMEZONE('UTC',_fivetran_synced) as _fivetran_synced
    FROM src_events
    )
SELECT * FROM events