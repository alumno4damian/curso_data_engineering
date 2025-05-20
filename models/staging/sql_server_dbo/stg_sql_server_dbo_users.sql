{{
  config(
    materialized='view'
  )
}}

WITH src_us AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_users') }}
    ),
src_info AS(
    SELECT *
    FROM {{ ref('base_data_users_info') }}
),
stg_us AS (
    SELECT
    su.user_id,
    first_name,
    last_name,
    updated_at,
    created_at,
    address_id,
    phone_number,
    email,
    sex,
    DATEDIFF(YEAR,birthdate,GETDATE()) age,
    pet,
    _fivetran_deleted,
    _fivetran_synced
    FROM src_us su 
    LEFT JOIN src_info si ON su.user_id=si.user_id
)
    
SELECT * FROM stg_us