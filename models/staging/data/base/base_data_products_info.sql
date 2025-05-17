{{
  config(
    materialized='view'
  )
}}

WITH src_prod AS (
    SELECT * 
    FROM {{ source('data', 'products_info') }}
    ),

base_prod AS (
    SELECT
        cast(name as varchar) name,
        cast(class as varchar) class,
        cast(flower as BOOLEAN) flower,
        cast(indoor_outdoor as varchar) indoor_outdoor,
        cast(care_difficult as varchar) care_difficult,
        cast(size as varchar) size,
        cast(image_url as varchar) image_url
    FROM src_prod
    )
    
SELECT * FROM base_prod