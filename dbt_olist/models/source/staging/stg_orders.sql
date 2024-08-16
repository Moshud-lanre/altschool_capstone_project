WITH orders AS (
    SELECT 
        o.order_id, 
        customer_id,
        product_id, 
        apporved_at, 
        delivered_customer_date, 
        oi.price,
        status
    FROM {{source('raw', 'orders')}} o 
    JOIN
        {{source('raw', 'order_items')}} oi
    ON 
        o.order_id  = oi.order_id
    WHERE 
        o.status = 'delivered'
)

SELECT * FROM orders