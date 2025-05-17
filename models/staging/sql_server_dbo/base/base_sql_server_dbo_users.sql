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
          cast(first_name as varchar) first_name,
          cast(last_name as varchar) as last_name,
          CONVERT_TIMEZONE('UTC', updated_at) as updated_at,
          CONVERT_TIMEZONE('UTC', created_at) as created_at,
          {{dbt_utils.generate_surrogate_key(['address_id'])}} as address_id,
          cast(phone_number as varchar) phone_number,
          cast(email as varchar) email,
          _fivetran_deleted,
          CONVERT_TIMEZONE('UTC', _fivetran_synced) as _fivetran_synced
    FROM src_users
    )

SELECT * FROM base_users