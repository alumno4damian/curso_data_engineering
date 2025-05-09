{{
  config(
    materialized='table'
  )
}}

WITH src_add AS (
    SELECT *
    FROM {{ ref('base_sql_server_dbo_addresses') }}
    ),

stg_add AS (
    SELECT
    address_id,
    desc_direccion,
    pais, 
    estado,
    codigo_postal
FROM src_add
    )

SELECT * FROM add