{{
  config(
    materialized='view'
  )
}}

{{ dbt_date.get_date_dimension("2020-01-01", "2026-12-31") }}

