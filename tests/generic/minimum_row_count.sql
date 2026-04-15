{% test minimum_row_count(model, min_rows) %}
{{ config(
    severity='warn'
    ) 
}}
    SELECT count(*) as count FROM {{ model }} having count(*) < {{ min_rows }}
{% endtest %}