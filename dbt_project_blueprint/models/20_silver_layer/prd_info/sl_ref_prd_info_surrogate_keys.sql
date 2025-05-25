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
        ref_table="sl_prd_info",
        key_columns=["prd_id"],
        sequence_name="bv_ref_prd_info_sequence_sk"
    )
}}