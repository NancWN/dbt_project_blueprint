
{{
    config(
        materialized='table',
        tags=['silver'],
    )
}}

/* =========== IMPORTS =============*/

with 

source as (
    select * from {{ ref('bl_crm_sales_details') }}
),

/* =========== DEFINTIONS =============*/

/* =========== TRANSFORMATIONS ========*/
metadata as (
    select 
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        case 
            when length (cast(sls_order_dt as text)) !=8 then to_date('19000101', 'YYYYMMDD')
            else to_date(cast(sls_order_dt as text),'YYYYMMDD')
        end as sls_order_dt,
        to_date(cast(sls_ship_dt as text),'YYYYMMDD') as sls_ship_dt,
        to_date(cast(sls_due_dt as text),'YYYYMMDD') as sls_due_dt,
        case 
            when sls_sales<=0 or sls_sales is null or sls_sales !=(sls_quantity * ABS(sls_price)) then sls_quantity * ABS(sls_price)
            else sls_sales
        end as sls_sales,
        sls_quantity,
        case 
            when sls_price=0 or sls_price is null then sls_sales / sls_quantity
            when sls_price<0 then sls_price*-1
            else sls_price
        end as sls_price,
        load_timestamp
    from source
)

select * from metadata