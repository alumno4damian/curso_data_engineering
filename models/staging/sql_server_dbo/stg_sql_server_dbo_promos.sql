{{
  config(
    materialized='view'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_promos') }}
    ),

stg_promos AS (
    SELECT
    promo_id,
    promo_desc,
    status,
    _fivetran_deleted,
    _fivetran_synced
    FROM src_promos
)
    
SELECT * FROM stg_promos