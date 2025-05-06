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
          address_id as addres_id_ant,
          zipcode as codigo_postal,
          country as pais,
          address as desc_direccion,
          state as estado,
          _fivetran_deleted,
          _fivetran_synced
    FROM src_addresses
    )

SELECT * FROM base_addresses

