

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
    select * from {{ ref('sl_cust_info') }}
),

bdate as (
    select * from {{ ref('sl_cust_bdate') }}
),

locations as (
    select * from {{ ref('sl_cust_loc') }}
),

sk as (
    select * from {{ ref('sl_ref_cust_info_surrogate_keys') }}
),


/* =========== DEFINTIONS =============*/


/* =========== TRANSFORMATIONS ========*/


customer as (
    select 
        sk.sk as customer_sk,
        base.cst_id as customer_id,
        base.cst_key as customer_key,
        base.cst_firstname as first_name,
        base.cst_lastname as last_name,
        locations.cst_country as country,
        base.cst_marital_status as marital_status,
        case 
            when base.cst_gndr='Unknown' and bdate.cst_gndr != 'Unknown' then bdate.cst_gndr
            else base.cst_gndr
        end as gender,
        bdate.cst_bdate as birthdate,
        base.cst_create_date as create_date
    from base
    inner join sk on base.cst_id=sk.cst_id
    left join bdate on base.cst_key = bdate.cst_key
    left join locations on base.cst_key = locations.cst_key
)

select * from customer