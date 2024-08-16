WITH delivery AS(
    SELECT
        order_id,
        avg_delivery_time
    FROM 
        {{ ref('int_avg_delivery_time') }} 
    

)

SELECT 
    round(sum(avg_delivery_time)/count(distinct order_id)) average_delivery_day
FROM
    delivery

