

{{
    config(
        materialized='table',
        tags=['silver'],
    )
}}

/* =========== IMPORTS =============*/

with 

source as (
    select * from {{ ref('bl_crm_cust_info') }}
),


/* =========== DEFINTIONS =============*/

newest_data as (
    select  
        *,
        row_number() over (
            partition by cst_id 
            order by cst_create_date desc, load_timestamp desc
        ) as rn
    from source 
),

/* =========== TRANSFORMATIONS ========*/


custo_info as (
    select 
        cst_id,
        cst_key,
        TRIM(cst_firstname) as cst_firstname,
        TRIM(cst_lastname) as cst_lastname,
        case 
            when UPPER(cst_marital_status)='M' then 'Married'
            when UPPER(cst_marital_status)='S' then 'Single'
            else 'Unknown'
        end as cst_marital_status,
        case 
            when UPPER(cst_gndr)='F' then 'Female'
            when UPPER(cst_gndr)='M' then 'Male'
            else 'Unknown'
        end as cst_gndr,
        cst_create_date,
        load_timestamp
    from newest_data
    where cst_id is not null and rn=1
)

select * from custo_info