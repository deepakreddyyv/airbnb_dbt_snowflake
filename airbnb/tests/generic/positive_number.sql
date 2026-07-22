{% test positive_number(model, column_name, delimeter='$') %}
    SELECT *
    FROM {{ model }}
    WHERE split({{ column_name }}, '{{ delimeter }}')[1]::float < 0
{% endtest %}