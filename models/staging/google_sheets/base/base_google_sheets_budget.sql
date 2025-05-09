{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

base_budget AS (
    SELECT
          {{dbt_utils.generate_surrogate_key(['product_id','month'])}} as budget_id,
          {{dbt_utils.generate_surrogate_key(['product_id'])}}product_id,
          month as fecha,
          cast(quantity as int) as cantidad,
          CONVERT_TIMEZONE('UTC',_fivetran_synced) as _fivetran_synced
    FROM src_budget
    )
    
SELECT * FROM base_budget