{{
  config(
    materialized='view'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

base_users AS (
    SELECT
          {{dbt_utils.generate_surrogate_key(['user_id'])}} as user_id,
          user_id as user,
          first_name as nombre,
          last_name as apellido,
          CONVERT_TIMEZONE('UTC', updated_at) as fecha_actualizacion,
          CONVERT_TIMEZONE('UTC', created_at) as fecha_creacion,
          address_id,
          phone_number as telefono,
          email as correo,
          _fivetran_deleted,
          CONVERT_TIMEZONE('UTC', _fivetran_synced) as _fivetran_synced
    FROM src_users
    )

SELECT * FROM base_users