-- Create schema
CREATE SCHEMA IF NOT EXISTS RAW;

-- Create Order items table
CREATE TABLE IF NOT EXISTS RAW.ORDER_ITEMS(
    order_id UUID NOT NULL,
    order_item_id INTEGER NOT NULL,
    product_id UUID NOT NULL,
    seller_id UUID NOT NULL,
    shipping_limit_date TIMESTAMP NOT NULL,
    price DECIMAL(7, 2) NOT NULL,
    freight_value DECIMAL(7, 2) NOT NULL
);

-- Load data into Order items table
COPY RAW.ORDER_ITEMS(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
FROM '/data/order_items.csv' DELIMITER ',' CSV HEADER ENCODING 'utf-8';


--Create Orders review table
CREATE TABLE IF NOT EXISTS RAW.ORDER_REVIEW(
    review_id UUID NOT NULL,
    order_id UUID NOT NULL,
    review_score INTEGER NOT NULL,
    review_comment_title VARCHAR,
    review_comment_msg TEXT,
    review_creation_date TIMESTAMP NOT NULL,
    review_answer_timestamp TIMESTAMP NOT NULL
);

--Load data into Order_review table
COPY RAW.ORDER_REVIEW(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_msg,
    review_creation_date,
    review_answer_timestamp
)
FROM '/data/order_reviews.csv' DELIMITER ',' CSV HEADER ENCODING 'utf-8';


--Create Orders table
CREATE TABLE IF NOT EXISTS RAW.ORDERS(
    order_id UUID NOT NULL PRIMARY KEY,
    customer_id UUID NOT NULL,
    status VARCHAR NOT NULL,
    purchase_timestamp TIMESTAMP NOT NULL,
    approved_at TIMESTAMP,
    delivered_carrier_date TIMESTAMP,
    delivered_customer_date TIMESTAMP ,
    estimated_delivery_date TIMESTAMP NOT NULL
);

--Load data into Orders table
COPY RAW.ORDERS(
    order_id ,
    customer_id ,
    status ,
    purchase_timestamp ,
    approved_at ,
    delivered_carrier_date ,
    delivered_customer_date ,
    estimated_delivery_date 
)
FROM '/data/orders.csv' DELIMITER ',' CSV HEADER ENCODING 'utf-8';


--Create Products table
CREATE TABLE IF NOT EXISTS RAW.PRODUCTS(
    product_id UUID NOT NULL PRIMARY KEY,
    category_name VARCHAR ,
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    photos_qty BIGINT,
    weight_g DECIMAL(7, 2),
    length_cm DECIMAL(7, 2),
    height_cm DECIMAL(7, 2),
    width_cm DECIMAL(7, 2)
);


--Load data into Products table
COPY RAW.PRODUCTS(
    product_id,
    category_name,
    product_name_lenght,
    product_description_lenght,
    photos_qty,
    weight_g,
    length_cm,
    height_cm,
    width_cm
)
FROM '/data/products.csv' DELIMITER ',' CSV HEADER ENCODING 'utf-8';

--Create Order payments table
CREATE TABLE IF NOT EXISTS RAW.ORDER_PAYMENTS(
    order_id UUID NOT NULL,
    payment_sequential INTEGER NOT NULL,
    payment_type VARCHAR NOT NULL,
    payment_installments INTEGER NOT NULL,
    payment_value DECIMAL(7, 2) NOT NULL
);

-- Load data into order_payments table
COPY RAW.ORDER_PAYMENTS(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
FROM '/data/order_payments.csv' DELIMITER ',' CSV HEADER ENCODING 'utf-8';

-- Create Product category table
CREATE TABLE IF NOT EXISTS RAW.PRODUCT_CATEGORY(
    category_name VARCHAR NOT NULL,
    category_name_english VARCHAR NOT NULL
);

COPY RAW.PRODUCT_CATEGORY(
    category_name,
    category_name_english
)
FROM '/data/product_category_name_translation.csv' DELIMITER ',' CSV HEADER ENCODING 'utf-8';


CREATE TABLE IF NOT EXISTS RAW.GEOLOCATION(
    zip_code_prefix BIGINT NOT NULL,
    latititude VARCHAR NOT NULL,
    longitude VARCHAR NOT NULL,
    city VARCHAR NOT NULL,
    state VARCHAR NOT NULL
);

COPY RAW.GEOLOCATION(
    zip_code_prefix,
    latititude,
    longitude,
    city,
    state
)
FROM '/data/geolocation.csv' DELIMITER ',' CSV HEADER ENCODING 'utf-8';


CREATE TABLE IF NOT EXISTS RAW.SELLERS(
    seller_id UUID NOT NULL PRIMARY KEY,
    zip_code_prefix BIGINT NOT NULL,
    city VARCHAR NOT NULL,
    state VARCHAR NOT NULL
);

COPY RAW.SELLERS(
    seller_id,
    zip_code_prefix,
    city,
    state
)
FROM '/data/sellers.csv' DELIMITER ',' CSV HEADER ENCODING 'utf-8';


CREATE TABLE IF NOT EXISTS RAW.CUSTOMERS(
    customer_id UUID NOT NULL,
    customer_unique_id UUID NOT NULL,
    zip_code_prefix BIGINT NOT NULL,
    city VARCHAR NOT NULL,
    state VARCHAR NOT NULL
);

COPY RAW.CUSTOMERS(
    customer_id,
    customer_unique_id,
    zip_code_prefix,
    city,
    state
)
FROM '/data/customers.csv' DELIMITER ',' CSV HEADER ENCODING 'utf-8';