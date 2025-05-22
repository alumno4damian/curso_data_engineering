{% test edad_valida(model, column_name, edad_min, edad_max) %}

SELECT *
FROM {{ model }}
WHERE 
  DATE_PART('year', AGE(CURRENT_DATE, {{ fecha }})) NOT BETWEEN {{ edad_min }} AND {{ edad_max }}
  OR {{ fecha }} IS NULL

{% endtest %}

