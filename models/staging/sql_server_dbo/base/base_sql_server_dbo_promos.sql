{{
  config(
    materialized='view'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    UNION ALL
    SELECT 'desconocida', 0, 'inactive', null, null
    ),

base_promos AS (
    SELECT
          {{dbt_utils.generate_surrogate_key(['promo_id'])}} as promo_id,
          lower(promo_id) as desc_promo,
          cast(discount as float) as descuento_euros,
          status as estado,
          _fivetran_deleted,
           CONVERT_TIMEZONE('UTC',_fivetran_synced) as _fivetran_synced
    FROM src_promos
    )

SELECT * FROM base_promos

