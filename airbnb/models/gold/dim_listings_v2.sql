{{
    config(
        materialized='view',
        schema='gold'
    )
}}

select 
    LISTING_ID
    ,LISTING_ID_SK
    ,LISTING_URL
    ,NAME
    ,ROOM_TYPE
    ,MINIMUM_NIGHTS
    ,HOST_ID
    ,PRICE
    ,CURRENCY
    ,SENTIMENT_SCORE
    --,cast(SENTIMENT_SCORE_NORMALIZED * 10 as NUMBER(20,6)) as SENTIMENT_SCORE_NORMALIZED
    ,SENTIMENT_SCORE_NORMALIZED * 10 as SENTIMENT_SCORE_NORMALIZED
    ,REVIEWS_COUNT
    ,CREATED_AT
    ,UPDATED_AT
    ,LOADED_AT
    ,DBT_SCD_ID
    ,DBT_UPDATED_AT
    ,START_DATE
    ,END_DATE
    
FROM {{ ref('silver_airbnb__listings_ss') }}
