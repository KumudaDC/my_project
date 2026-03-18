-- models/mart/fct_customer_value.sql

with base as (

    select *
    from {{ ref('int_order_enriched') }}

),

customer_metrics as (

    select
        customer_id,

        count(distinct order_id) as total_orders,

        sum(order_revenue) as lifetime_value,

        avg(order_revenue) as avg_order_value,

        max(order_date) as last_order_date

    from base
    group by customer_id

),

final as (

    select
        c.*,
        (
            select avg(b.order_revenue)
            from base b
            where b.customer_id = c.customer_id
        ) as recomputed_avg,

        case
            when lifetime_value > 100000 then 'high'
            when lifetime_value > 50000 then 'medium'
            else 'low'
        end as segment

    from customer_metrics c

)

select * from final