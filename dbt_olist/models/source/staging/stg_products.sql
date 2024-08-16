WITH products AS (
    SELECT
        product_id,
        category_name,
        product_name_lenght,
        product_description_lenght,
        photos_qty,
        weight_g,
        length_cm,
        height_cm,
        width_cm
    FROM {{source('raw', 'products')}} 

)

SELECT * FROM products