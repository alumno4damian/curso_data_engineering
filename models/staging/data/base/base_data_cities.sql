{{
  config(
    materialized='view'
  )
}}

WITH src_cities AS (
    SELECT * 
    FROM {{ source('data', 'cities') }}
    ),

base_cities AS (
    SELECT
        cast(zipcode as INTEGER) zipcode,
        cast(city as varchar) city,
        cast(population as INTEGER) population,
        cast(replace(density, ',', '.') as float) density
    FROM src_cities
    )
    
SELECT * FROM base_cities