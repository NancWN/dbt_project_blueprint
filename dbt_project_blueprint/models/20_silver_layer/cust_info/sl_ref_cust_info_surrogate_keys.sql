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
        ref_table="sl_cust_info",
        key_columns=["cst_id"],
        sequence_name="bv_ref_cust_info_sequence_sk"
    )
}}