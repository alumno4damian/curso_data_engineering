{{
  config(
    materialized='table',
    unique_key='event_id'
  )
}}

WITH  events as (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_events' )}}
    {% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}
)

select 
event_id,
page_url,
event_type_id,
producto_id,
session_id,
created_at,
order_id
from 
events
