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
          zipcode as codigo_postal,
          country as pais,
          address as desc_direccion,
          state as estado,
          _fivetran_deleted,
          CONVERT_TIMEZONE('UTC',_fivetran_synced) as _fivetran_synced
    FROM src_addresses
    )

SELECT * FROM base_addresses

