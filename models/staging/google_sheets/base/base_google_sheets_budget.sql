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
          product_id,
          month as fecha,
          quantity as cantidad,
          _fivetran_synced
    FROM src_budget
    )

SELECT * FROM base_budget