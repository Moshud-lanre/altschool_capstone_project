#Create bucket
resource "google_storage_bucket" "my_cap_buck" {
  name          = "my-olist-bucket"
  location      = "europe-west1"
}


# # Dataset creation
resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "raw"
  description                 = "This holds the raw data for the ecommerce store "
  location                    = "europe-west1"

}


variable "files" {
  type = map(string)
  default = {
    # sourcefile = destfile
    "schema_scripts/cat_name_translation.json" = "schema/cat_name_translation.json",
    "schema_scripts/customers.json"  = "schema/customers.json",
    "schema_scripts/geoloc.json" = "schema/geoloc.json",
    "schema_scripts/order_items.json" = "schema/order_items.json",
    "schema_scripts/order_payments.json" = "schema/order_payments.json",
    "schema_scripts/order_review.json" = "schema/order_reviews.json",
    "schema_scripts/orders.json" = "schema/orders.json",
    "schema_scripts/products.json" = "schema/products.json",
    "schema_scripts/sellers.json" = "schema/sellers.json"
  }
}
resource "google_storage_bucket_object" "my-config-objects" {
  for_each = var.files
  name     = each.value
  source   = "${path.module}/${each.key}"
  bucket   = "my-olist-bucket"
}
