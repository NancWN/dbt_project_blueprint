{{
    config(
        materialized="incremental",
        tags=["silver","ref","surrogate_keys"],
        full_refresh = none if var('allow_full_refresh', false) else false,
    )
}}


/* ====== IMPORTS ============== */

/* ====== DEFINITIONS ========== */


/* ====== TRANSFORMATIONS ====== */

{{
    create_surrogate_keys(
        ref_table="sl_sales_details",
        key_columns=["sls_ord_num", "sls_prd_key", "sls_cust_id"],
        sequence_name="bv_ref_sales_details_sequence_sk"
    )
}}