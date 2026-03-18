-- models/staging/stg_orders.sql

with source as (

    select *
    from {{ source('tpch', 'orders') }}

),

renamed as (

    select
        cast(o_orderkey as string) as order_id,
        cast(o_custkey as string) as customer_id,
        o_orderstatus as status,
        o_totalprice as total_price,
        o_orderdate as order_date,
        o_orderpriority as priority

    from source

)

select * from renamed