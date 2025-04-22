
with 

source as (
    select * from {{ ref('sales_datei') }}
),

metadata as (
    select 
        *,
        '{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}'::timestamp as load_timestamp
    from source
)

select * from metadata