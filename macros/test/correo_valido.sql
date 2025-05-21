{% test correo_valido(model, column_name) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} NOT LIKE '%@%' OR {{ column_name }} IS NULL

{% endtest %}
