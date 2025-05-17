{{
  config(
    materialized='view'
  )
}}

WITH src_class AS (
    SELECT distinct class 
    FROM {{ ref('base_data_products_info') }}
    ),

stg_class AS (
    SELECT
    {{dbt_utils.generate_surrogate_key(['class'])}} as class_id,
    class
    FROM src_class
)    
SELECT * FROM stg_class
order by class