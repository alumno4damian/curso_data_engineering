{{
  config(
    materialized='view'
  )
}}

WITH src_add AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_addresses') }}
    ),

stg_add AS (
    SELECT
        address_id,
        address,
        zipcode as city_id,
        _fivetran_synced,
        _fivetran_deleted
    FROM src_add
    )
    
SELECT * FROM stg_add