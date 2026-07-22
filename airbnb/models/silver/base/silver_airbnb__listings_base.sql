{{
    config(
        materialized='ephemeral',
    )
}}

with reviews as (
    SELECT
        LISTING_ID
        ,DATE
        ,REVIEWER_NAME
        ,COMMENTS
        ,SENTIMENT
        ,loaded_at
    FROM {{ ref('bronze_airbnb__reviews') }}
    qualify row_number() over (partition by LISTING_ID, DATE, REVIEWER_NAME order by DATE desc) = 1
),

reviews_aggreate as (
    select 
        listing_id
        ,sum(case 
            when sentiment = 'positive' then 1
            when sentiment = 'neutral' then 0
            when sentiment = 'negative' then -1
        end) as sentiment_score
        ,count(listing_id) as reviews_count
    from {{ ref('bronze_airbnb__reviews') }}
    group by all
)

SELECT
    ID as LISTING_ID
    ,{{ dbt_utils.generate_surrogate_key(['id']) }} as listing_id_sk
    ,LISTING_URL
    ,NAME
    ,ROOM_TYPE
    ,MINIMUM_NIGHTS
    ,HOST_ID
    ,split(price, '$')[1]::FLOAT as price
    ,'US DOLLOR' as currency
    ,r.sentiment_score
    ,(
        (r.sentiment_score - (select min(sentiment_score) from reviews_aggreate)) 
        / 
        ((select max(sentiment_score) from reviews_aggreate) - (select min(sentiment_score) from reviews_aggreate))
    ) as sentiment_score_normalized
    ,r.reviews_count
    ,CREATED_AT
    ,UPDATED_AT
    ,LOADED_AT

FROM {{ ref('bronze_airbnb__listings') }} l
LEFT JOIN reviews_aggreate r on l.id = r.listing_id