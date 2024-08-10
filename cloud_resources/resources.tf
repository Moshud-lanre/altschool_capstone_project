#Create bucket
resource "google_storage_bucket" "my_cap_buck" {
  name          = "my-olist-bucket"
  location      = "us-central1"
}
# Dataset creation
resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "olist_raw"
  description                 = "This holds the raw data for the ecommerce store "
  location                    = "US"

}

