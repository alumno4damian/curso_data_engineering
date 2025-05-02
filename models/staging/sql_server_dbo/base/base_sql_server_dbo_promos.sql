{{
  config(
    materialized='view'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

base_promos AS (
    SELECT
          generate_surrogate_key (promo_id)
          promo_id as desc_promo,
          discount as descuento_euros,
          status as estado,
          _fivetran_deleted,
          _fivetran_synced
    FROM src_promos
    )

SELECT * FROM base_promos