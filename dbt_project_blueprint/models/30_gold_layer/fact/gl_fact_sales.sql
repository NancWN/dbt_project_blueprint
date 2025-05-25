

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
    select * from {{ ref('sl_sales_details') }}
),

cust as (
    select * from {{ ref('sl_ref_cust_info_surrogate_keys') }}
),

prd as (
    select * from {{ ref('sl_prd_info') }}
    where is_current = true and prd_end_dt='9999-12-30'
),

prd_sk as (
    select * from {{ ref('sl_ref_prd_info_surrogate_keys') }}
),

sk as (
    select * from {{ ref('sl_ref_sales_details_surrogate_keys') }}
),


/* =========== DEFINTIONS =============*/


/* =========== TRANSFORMATIONS ========*/


sales as (
    select 
        sk.sk as sales_sk,
        base.sls_ord_num as sales_order_number,
        base.sls_prd_key as sales_product_key,
        base.sls_cust_id as sales_customer_id,
        base.sls_order_dt as sales_order_date,
        base.sls_ship_dt as sales_ship_date,
        base.sls_due_dt as sales_due_date,
        base.sls_sales as total_sales_amount,
        base.sls_quantity as sales_quantity,
        base.sls_price as sales_price,
        cust.sk as customer_fk,
        prd_sk.sk as product_fk
    from base
    inner join sk on base.sls_ord_num=sk.sls_ord_num
                  and base.sls_cust_id = sk.sls_cust_id
                  and base.sls_prd_key = sk.sls_prd_key
    left join cust on base.sls_cust_id = cust.cst_id
    left join prd on base.sls_prd_key = prd.prd_key
    left join prd_sk on prd.prd_id=prd_sk.prd_id
)

select * from sales