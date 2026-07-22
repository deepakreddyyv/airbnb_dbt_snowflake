{{
    config(
        materialized='view',
        schema='gold',
        alias='dim_hosts'
    )
}}

select 
    *
FROM {{ ref('silver_airbnb__hosts_ss') }}
