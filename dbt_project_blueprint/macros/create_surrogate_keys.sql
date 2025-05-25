{% macro create_surrogate_keys(ref_table,key_columns,sequence_name) %}



with

/* ====== import ============== */
source as (
    select * from {{ ref(ref_table) }}
),


/* ====== transformations ====== */

-- schritt 1: extrahiere die eindeutigen keys aus dem ref
hashkeys as (
    select
        {% for column in key_columns %}
        {{ column }}{% if not loop.last %},{% endif %}
        {% endfor %}
    from source
),

-- schritt 2: entferne duplikate und sortiere die hashkeys
ordered_hashkeys as (
    select distinct * from hashkeys
    order by
        {% for column in key_columns %}
        {{ column }}{% if not loop.last %},{% endif %}
        {% endfor %}
),

--- schritt 3: weise jedem hashkey eine eindeutige surrogatschlüssel-id (sk) aus einer sequenz zu
--             es werden nur neue hashkeys verarbeitet, die noch nicht in der zieltabelle vorhanden sind = incremental
mapped_hashkeys as (
    select
        {% for column in key_columns %}
        {{ column }},
        {% endfor %}
        nextval('{{ target.schema }}.{{ sequence_name }}') as sk
    from ordered_hashkeys
    {% if is_incremental() -%}
        where not exists (
            select 1
            from {{ this }} as this
            where
                {% for column in key_columns %}
                ordered_hashkeys.{{ column }}=this.{{ column }}{% if not loop.last %} and{% endif %}
                {% endfor %}
        )
    {%- endif %}
)

select * from mapped_hashkeys

{% endmacro %}