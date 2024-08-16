WITH delivery AS(
    SELECT
        order_id,
        apporved_at,
        delivered_customer_date,
        date_diff(delivered_customer_date, apporved_at, day) AS delivery_time
    FROM 
        {{ ref('stg_orders') }} 
    

)

SELECT 
    order_id,
    AVG(delivery_time) AS avg_delivery_time
FROM
    delivery
GROUP BY
    order_id