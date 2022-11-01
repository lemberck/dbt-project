
{{
    config(
        materialized='table',
        post_hook=["
            GRANT USAGE ON SCHEMA {{target.schema}} TO GROUP biusers;
            GRANT SELECT ON TABLE {{target.schema}}.bireport TO GROUP biusers;
        "]
    )

}}

select * from {{ref('joins')}}

