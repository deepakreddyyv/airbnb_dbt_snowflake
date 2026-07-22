{{
    config(
        materialized='view',
        schema='bronze'
    )
}}

SELECT
    -- LISTING_ID || '|' || DATE || '|' || REVIEWER_NAME as review_id
    LISTING_ID
    ,DATE
    ,REVIEWER_NAME
    ,COMMENTS
    ,SENTIMENT
    ,current_timestamp() as loaded_at
FROM {{ source('airbnb', 'src_reviews') }}