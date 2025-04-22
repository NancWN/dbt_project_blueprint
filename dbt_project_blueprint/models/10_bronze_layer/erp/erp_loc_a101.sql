
with 

source as (
    select * from {{ ref('loc_a101') }}
),

metadata as (
    select 
        *,
        '{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}'::timestamp as load_timestamp
    from source
)

select * from metadata