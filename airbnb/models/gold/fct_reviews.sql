{{
    config(
        materialized='incremental',
        incremental_strategy='append',
        schema='gold',
        alias='fct_reviews'
    )
}}

with listings as (
    select 
        listing_id
        ,host_id
        ,name
        ,room_type
        ,minimum_nights
        ,price
        ,reviews_count
        ,sentiment_score
        ,sentiment_score_normalized
        ,created_at
        ,updated_at
        ,start_date
        ,end_date
    from {{ ref('dim_listings') }}
    where end_date = '9999-12-31'
    {% if is_incremental() %}
        and updated_at > (select max(updated_at) from {{ this }})
    {% endif %}
),

hosts as (
    select
        host_id
        ,is_superhost
    from {{ ref('dim_hosts') }}
    where end_date = '9999-12-31'
)

select 
    l.listing_id || ' ' || l.host_id as id
    ,l.listing_id
    ,l.host_id
    ,l.name
    ,l.room_type
    ,l.minimum_nights
    ,l.price
    ,h.is_superhost
    ,l.reviews_count
    ,l.sentiment_score
    ,CAST(l.sentiment_score_normalized AS NUMBER(20,6)) as SENTIMENT_SCORE_NORMALIZED
    ,l.created_at
    ,l.updated_at
    ,l.start_date
    ,l.end_date
from listings l
left join hosts h on l.host_id = h.host_id