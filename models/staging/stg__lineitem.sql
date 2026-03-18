-- models/staging/stg_lineitem.sql

with source as (

    select *
    from {{ source('tpch', 'lineitem') }}

),

renamed as (

    select
        cast(l_orderkey as string) as order_id,
        l_partkey,
        l_quantity,
        l_extendedprice,
        l_shipdate

    from source

)

select * from renamed