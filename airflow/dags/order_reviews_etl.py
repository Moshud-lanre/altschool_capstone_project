from airflow import DAG
from airflow.providers.google.cloud.transfers.postgres_to_gcs import PostgresToGCSOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from datetime import datetime, timedelta
from airflow.models import Variable


BQ_BUCKET = Variable.get("BQ_BUCKET")
SCHEMA_OBJ6 = Variable.get("SCHEMA_OBJ6")
PG_SCHEMA = Variable.get("PG_SCHEMA")
PG_TABLE6 = Variable.get("PG_TABLE6")
CONN_ID = Variable.get("CONN_ID")
FILENAME6 = Variable.get("filename6")
PG_CONN_ID = Variable.get("PG_CONN_ID")
BQ_PROJECT = Variable.get("BQ_PROJECT")
BQ_DATASET = Variable.get("BQ_DATASET")
BQ_TABLE6 = Variable.get("BQ_TABLE6")









default_args = {
   'owner': 'Olanrewaju Moshood',
   'depends_on': False,
   'email_on_failure': False,
   'email_on_retry':False,
   'start_date': datetime(2024, 8, 11),
   'retries': 1,
   'retry_delay': timedelta(minutes=2) 
}

dag = DAG(
    "order_reviews_etl",
    default_args=default_args,
    description="A dag to load data from pstgres to bigquery",
    schedule_interval=None,
    catchup=False
)

order_reviews_gcs = PostgresToGCSOperator(
    task_id = "postgres_to_gcs",
    sql = f'select * from {PG_SCHEMA}.{PG_TABLE6};',
    bucket = BQ_BUCKET,
    filename = FILENAME6,
    export_format = "CSV",
    postgres_conn_id = PG_CONN_ID,
    field_delimiter = ',',
    gzip = False,
    task_concurrency = 1,
    gcp_conn_id = CONN_ID,
    dag=dag
)

order_reviews_bq = GCSToBigQueryOperator(
    task_id = "Load_order_review_data_to_bq",
    bucket = BQ_BUCKET,
    source_objects = [FILENAME6],
    destination_project_dataset_table = f'{BQ_PROJECT}.{BQ_DATASET}.{BQ_TABLE6}',
    schema_object= SCHEMA_OBJ6,
    max_bad_records = 10000,
    create_disposition = "CREATE_IF_NEEDED",
    write_disposition="WRITE_TRUNCATE",
     gcp_conn_id=CONN_ID,
    dag=dag,
)

order_reviews_gcs >> order_reviews_bq