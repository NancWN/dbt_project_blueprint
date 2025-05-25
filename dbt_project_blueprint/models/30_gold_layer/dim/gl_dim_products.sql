

{{
    config(
        materialized='table',
        tags=['gold'],
        schema='gold',
    )
}}

/* =========== IMPORTS =============*/

with 

base as (
    select * from {{ ref('sl_prd_info') }}
),

cat as (
    select * from {{ ref('sl_prd_cat') }}
),

sk as (
    select * from {{ ref('sl_ref_prd_info_surrogate_keys') }}
),


/* =========== DEFINTIONS =============*/


/* =========== TRANSFORMATIONS ========*/


product as (
    select 
        sk.sk as product_sk,
        base.prd_id as product_id,
        base.prd_key as product_key,
        base.cat_id as category_id,
        base.prd_name as product_name,
        base.prd_desc as product_desc,
        base.prd_cost as product_cost,
        base.prd_line as product_line,
        base.prd_start_dt as product_start_date,
        base.prd_end_dt as product_end_date,
        cat.cat as category,
        cat.sub_cat as sub_category,
        cat.MAINTENANCE as maintenance
    from base
    inner join sk on base.prd_id=sk.prd_id
    left join cat on base.cat_id = cat.cat_id
    where base.is_current = true and prd_end_dt='9999-12-30'
)

select * from product