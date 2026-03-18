with orders as (

    select *
    from {{ ref('stg__orders') }}

),

lineitem as (

    select *
    from {{ ref('stg__lineitem') }}

),

joined as (

    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.total_price,

        l.l_partkey,
        l.l_quantity,
        l.l_extendedprice,
        sum(l.l_extendedprice) over (partition by o.order_id) as order_revenue,
        avg(l.l_extendedprice) over (partition by o.order_id) as avg_item_price,
        count(*) over (partition by o.order_id) as item_count,

        row_number() over (
            partition by o.customer_id
            order by o.order_date desc
        ) as order_rank

    from orders o
    join lineitem l
        on o.order_id = l.order_id

)

select * from joined