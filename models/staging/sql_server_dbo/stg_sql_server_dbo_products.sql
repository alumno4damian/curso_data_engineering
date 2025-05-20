{{
  config(
    materialized='view'
  )
}}

WITH src_prod AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_products') }}
    ),
src_info AS(
    SELECT *
    FROM {{ ref('base_data_products_info') }}
),
stg_prod AS (
    SELECT
    product_id,
    sp.name,
    inventory,
    {{dbt_utils.generate_surrogate_key(['class'])}} as class_id,
    flower,
    indoor,
    care_difficult,
    size,
    image_url,
    _fivetran_deleted,
    _fivetran_synced
    FROM src_prod sp 
    LEFT JOIN src_info si ON sp.name=si.name
)
    
SELECT * FROM stg_prod