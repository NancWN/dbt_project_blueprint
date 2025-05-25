

{{
    config(
        materialized='table',
        tags=['silver'],
    )
}}

/* =========== IMPORTS =============*/

with 

source as (
    select * from {{ ref('bl_erp_cust_az12') }}
),


/* =========== DEFINTIONS =============*/


/* =========== TRANSFORMATIONS ========*/


custo_bdate as (
    select 
        cid ,
        REPLACE(cid, 'NAS', '') AS cst_key,
        case 
            when bdate > current_date then Null
            else bdate
        end  as cst_bdate,
        case 
            when UPPER(trim(gen))='M' then 'Male'
            when UPPER(trim(gen))='F' then 'Female'
            when gen is null then 'Unknown'
            else gen
        end as cst_gndr,
        load_timestamp
    from source
)

select * from custo_bdate