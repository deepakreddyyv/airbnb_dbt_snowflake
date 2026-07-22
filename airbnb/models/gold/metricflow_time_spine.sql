-- models/marts/metricflow_time_spine.sql
{{
    config(materialized = 'table')
}}

with days as (
    {{ dbt.date_spine(
        'day',
        "to_date('01/01/2000','mm/dd/yyyy')",
        "to_date('01/01/2030','mm/dd/yyyy')"
    ) }}
)
select cast(date_day as date) as date_day
from days