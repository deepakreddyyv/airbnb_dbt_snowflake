
{{
    config(
        materialized='view'
    )
}}

with src_hosts as (
    select 
        *
    from {{ ref('src_hosts') }}
)

select 
    host_id,
    NVL(host_name, 'Anonymous') as host_name,
    -- case when is_superhost = 't' then TRUE else FALSE end as is_superhost,
    is_superhost,
    created_at,
    updated_at
from src_hosts