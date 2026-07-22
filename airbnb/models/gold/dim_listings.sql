{{
    config(
        materialized='view',
        schema='gold',
        alias='dim_listings'
    )
}}

select 
    *
FROM {{ ref('silver_airbnb__listings_ss') }}
