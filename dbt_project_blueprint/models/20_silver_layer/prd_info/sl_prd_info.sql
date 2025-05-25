

{{
    config(
        materialized='table',
        tags=['silver'],
    )
}}

/* =========== IMPORTS =============*/

with 

source as (
    select * from {{ ref('bl_crm_prd_info') }}
),


/* =========== DEFINTIONS =============*/
add_new_column as (
    select  
        *,
        row_number() over (
            partition by prd_id
            order by prd_start_dt desc, load_timestamp desc 
        ) as rn,
        lead(prd_start_dt, 1, '9999-12-31') over (
            partition by prd_key
            order by prd_start_dt asc, load_timestamp desc 
        )-1 as new_prd_end_dt
    from source 
),


/* =========== TRANSFORMATIONS ========*/


prd_info as (
    select 
        prd_id,
        REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,         --in order to join with customer_location
        SUBSTRING(prd_key,7) as prd_key,                           --in order to join with crm_sales_details
        TRIM(SPLIT_PART(prd_nm,'-',1)) as prd_name,
        TRIM(SPLIT_PART(prd_nm,'-',2)) as prd_desc,
        COALESCE(prd_cost,0) as prd_cost,
        case UPPER(TRIM(prd_line))
            when 'R' then 'Road'
            when 'T' then 'Touring'
            when 'S' then 'Other Sales'
            when 'M' then 'Mountain'
            else 'Unknown'
        end as prd_line,
        prd_start_dt,
        new_prd_end_dt as prd_end_dt,
         case 
            when rn=1 then True
            else False
        end as is_current,
        load_timestamp
    from add_new_column
)

select * from prd_info
