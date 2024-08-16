WITH sales AS(
    SELECT
        order_id,
        p.category_name,
        price
    FROM 
        {{ ref('stg_orders') }} o
    JOIN
        {{ ref ('stg_products') }} p
    ON
        o.product_id = p.product_id

)

SELECT 
    category_name,
    SUM(price) AS total_sales
FROM
    sales
GROUP BY
    category_name
