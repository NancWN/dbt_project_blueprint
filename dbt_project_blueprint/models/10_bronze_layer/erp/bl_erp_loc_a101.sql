{{
        config(
        materialized='table',
        tags=['bronze']
    )
}}

with 

source as (
    select * from {{ ref('loc_a1012') }}
),

metadata as (
    select 
        CID,
        CNTRY,
        '{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}'::timestamp as load_timestamp
    from source
)

select * from metadata