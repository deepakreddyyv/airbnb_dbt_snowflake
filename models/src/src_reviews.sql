
with src_reviews as (
    select * from {{ source('airbnb', 'reviews') }}
)
select 
    LISTING_ID,
    DATE as REVIEW_DATE,
    REVIEWER_NAME,
    COMMENTS as REVIEW_COMMENTS,
    SENTIMENT as REVIEW_SENTIMENT,    
from src_reviews