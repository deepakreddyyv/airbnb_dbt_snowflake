{{
    config(
        materialized='ephemeral',
    )
}}

SELECT
    ID as HOST_ID
    ,{{ dbt_utils.generate_surrogate_key(['id']) }} as host_id_sk
    ,NAME
    ,case 
        when IS_SUPERHOST = 't' then true
        else false
    end as is_superhost
    ,CREATED_AT
    ,UPDATED_AT
    ,LOADED_AT
FROM {{ ref('bronze_airbnb__hosts') }}