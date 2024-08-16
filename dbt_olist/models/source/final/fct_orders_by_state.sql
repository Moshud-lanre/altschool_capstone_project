WITH order_state AS(
    SELECT
        o.customer_id,
        c.state,
        order_id
    FROM 
        {{ ref('stg_orders') }} o
    JOIN
        {{ source('raw', 'customers') }} c 
    ON
        o.customer_id = c.customer_id

)

SELECT 
    state,
    count(order_id) AS num_of_orders
FROM
    order_state
GROUP BY
    state
ORDER BY
    num_of_orders DESC