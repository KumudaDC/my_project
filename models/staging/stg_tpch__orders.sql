with renamed as 
( 
    select O_ORDERKEY as order_key, O_CUSTKEY as customer_key, O_ORDERSTATUS as order_status, 
    O_TOTALPRICE::decimal(18,2) as total_price, O_ORDERDATE as order_date, O_ORDERPRIORITY as order_priority, 
    O_CLERK as clerk, O_SHIPPRIORITY as ship_priority, 
    O_COMMENT as comment from {{ source("tpch", "orders") }} ) 
select *, 
case when total_price > 100000 then true else false end as is_high_value 
from renamed 