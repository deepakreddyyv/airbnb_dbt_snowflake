{{
    config(
        materialized='view',
        schema='silver',
        enabled= false
    )
}}

SELECT
    LISTING_ID
    ,DATE
    ,REVIEWER_NAME
    ,COMMENTS
    ,SENTIMENT
    ,loaded_at
FROM {{ ref('bronze_airbnb__reviews') }}
qualify row_number() over (partition by LISTING_ID, DATE, REVIEWER_NAME order by DATE desc) = 1