CREATE TABLE "order_items"(
    "order_id" UUID NOT NULL,
    "order_item_id" INTEGER NOT NULL,
    "product_id" UUID NOT NULL,
    "seller_id" UUID NOT NULL,
    "shipping_limit_date" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "price" DECIMAL(8, 2) NOT NULL,
    "freight_value" DECIMAL(8, 2) NOT NULL
);
ALTER TABLE
    "order_items" ADD PRIMARY KEY("order_id");
CREATE TABLE "order_review"(
    "review_id" UUID NOT NULL,
    "order_id" UUID NOT NULL,
    "review_score" INTEGER NOT NULL,
    "review_comment_title" VARCHAR(255) NOT NULL,
    "review_comment_msg" TEXT NOT NULL,
    "review_creation_date" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "review_answer_timestamp" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
ALTER TABLE
    "order_review" ADD PRIMARY KEY("review_id");
CREATE TABLE "order"(
    "order_id" UUID NOT NULL,
    "customer_id" UUID NOT NULL,
    "status" VARCHAR(255) NOT NULL,
    "purchase_timestamp" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "approved_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "delivered_carrier_date" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "delivered_customer_date" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "estimated_delivery_date" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
ALTER TABLE
    "order" ADD PRIMARY KEY("order_id");
CREATE TABLE "products"(
    "product_id" UUID NOT NULL,
    "category_name" VARCHAR(255) NOT NULL,
    "product_name_lenght" INTEGER NOT NULL,
    "product_description_lenght" INTEGER NOT NULL,
    "photos_qty" BIGINT NOT NULL,
    "weight_g" DECIMAL(8, 2) NOT NULL,
    "length_cm" DECIMAL(8, 2) NOT NULL,
    "height_cm" DECIMAL(8, 2) NOT NULL,
    "width_cm" DECIMAL(8, 2) NOT NULL
);
ALTER TABLE
    "products" ADD PRIMARY KEY("product_id");
CREATE TABLE "order_payments"(
    "order_id" UUID NOT NULL,
    "payment_sequential" INTEGER NOT NULL,
    "payment_type" VARCHAR(255) NOT NULL,
    "payment_installments" INTEGER NOT NULL,
    "payment_value" DECIMAL(8, 2) NOT NULL
);
ALTER TABLE
    "order_payments" ADD PRIMARY KEY("order_id");
CREATE TABLE "product_category"(
    "category_name" VARCHAR(255) NOT NULL,
    "category_name_english" VARCHAR(255) NOT NULL
);
CREATE TABLE "geolocation"(
    "zip_code_prefix" BIGINT NOT NULL,
    "latititude" BIGINT NOT NULL,
    "longitude" BIGINT NOT NULL,
    "city" VARCHAR(255) NOT NULL,
    "state" VARCHAR(255) NOT NULL
);
CREATE TABLE "sellers"(
    "seller_id" UUID NOT NULL,
    "zip_code" BIGINT NOT NULL,
    "city" VARCHAR(255) NOT NULL,
    "state" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "sellers" ADD PRIMARY KEY("seller_id");
CREATE TABLE "customers"(
    "customer_id" UUID NOT NULL,
    "customer_unique_id" UUID NOT NULL,
    "zip_code_prefix" BIGINT NOT NULL,
    "city" VARCHAR(255) NOT NULL,
    "state" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "customers" ADD PRIMARY KEY("customer_unique_id");
ALTER TABLE
    "order_items" ADD CONSTRAINT "order_items_freight_value_foreign" FOREIGN KEY("freight_value") REFERENCES "products"("product_id");
ALTER TABLE
    "product_category" ADD CONSTRAINT "product_category_category_name_foreign" FOREIGN KEY("category_name") REFERENCES "products"("product_description_lenght");
ALTER TABLE
    "order" ADD CONSTRAINT "order_status_foreign" FOREIGN KEY("status") REFERENCES "customers"("zip_code_prefix");
ALTER TABLE
    "order_review" ADD CONSTRAINT "order_review_review_comment_msg_foreign" FOREIGN KEY("review_comment_msg") REFERENCES "order"("order_id");
ALTER TABLE
    "customers" ADD CONSTRAINT "customers_customer_id_foreign" FOREIGN KEY("customer_id") REFERENCES "geolocation"("longitude");
ALTER TABLE
    "order_payments" ADD CONSTRAINT "order_payments_payment_installments_foreign" FOREIGN KEY("payment_installments") REFERENCES "order"("order_id");
ALTER TABLE
    "geolocation" ADD CONSTRAINT "geolocation_latititude_foreign" FOREIGN KEY("latititude") REFERENCES "sellers"("seller_id");
ALTER TABLE
    "order_items" ADD CONSTRAINT "order_items_product_id_foreign" FOREIGN KEY("product_id") REFERENCES "order"("status");