{{
  config(
    materialized='view'
  )
}}


WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

base_addresses AS (
    SELECT
          {{dbt_utils.generate_surrogate_key(['address_id'])}} as address_id,
          cast(zipcode as integer) zipcode,
          cast(country as varchar) country,
          cast(address as varchar) as address,
          cast(state as varchar) as state,
          _fivetran_deleted,
          CONVERT_TIMEZONE('UTC',_fivetran_synced) as _fivetran_synced
    FROM src_addresses
    )

SELECT * FROM base_addresses

