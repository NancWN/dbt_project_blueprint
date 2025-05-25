
{{
        config(
        materialized='table',
        tags=['bronze']
    )
}}

with 

source as (
    select * from {{ ref('px_cat_g1v22') }}
),

metadata as (
    select 
        *,
        '{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}'::timestamp as load_timestamp
    from source
)

select * from metadata