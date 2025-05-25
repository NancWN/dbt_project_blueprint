

{{
    config(
        materialized='table',
        tags=['silver'],
    )
}}

/* =========== IMPORTS =============*/

with 

source as (
    select * from {{ ref('bl_erp_px_cat_g1v2') }}
),


/* =========== DEFINTIONS =============*/


/* =========== TRANSFORMATIONS ========*/


prd_cat as (
    select 
        ID as cat_id,
        CAT,
        SUBCAT as sub_cat,
        MAINTENANCE,
        load_timestamp
    from source
)

select * from prd_cat