

{{
    config(
        materialized='table',
        tags=['silver'],
    )
}}

/* =========== IMPORTS =============*/

with 

source as (
    select * from {{ ref('bl_erp_loc_a101') }}
),


/* =========== DEFINTIONS =============*/


/* =========== TRANSFORMATIONS ========*/


custo_loc as (
    select 
        cid,
        REPLACE(cid, '-', '') AS cst_key,
        case 
            when UPPER(trim(cntry)) = 'DE' then 'Germany'
            when UPPER(trim(cntry )) in ('US', 'USA') then 'United States'
            when cntry is null or trim(cntry)='' then 'Unknown'
            else cntry
        end as cst_country,
        load_timestamp
    from source
)

select * from custo_loc