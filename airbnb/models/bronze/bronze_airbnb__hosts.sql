{{
    config(
        materialized='view',
        schema='bronze'    
    )
}}

SELECT 
    *,
    current_timestamp() as loaded_at
FROM {{ source('airbnb', 'src_hosts') }}