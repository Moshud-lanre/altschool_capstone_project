from airflow import DAG
from airflow.providers.google.cloud.transfers.postgres_to_gcs import PostgresToGCSOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from datetime import datetime, timedelta
from airflow.models import Variable


BQ_BUCKET = Variable.get("BQ_BUCKET")
SCHEMA_OBJ9 = Variable.get("SCHEMA_OBJ9")
PG_SCHEMA = Variable.get("PG_SCHEMA")
PG_TABLE9 = Variable.get("PG_TABLE9")
CONN_ID = Variable.get("CONN_ID")
FILENAME9 = Variable.get("filename9")
PG_CONN_ID = Variable.get("PG_CONN_ID")
BQ_PROJECT = Variable.get("BQ_PROJECT")
BQ_DATASET = Variable.get("BQ_DATASET")
BQ_TABLE9 = Variable.get("BQ_TABLE9")





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
    "sellers_etl",
    default_args=default_args,
    description="A dag to load data from postgres to bigquery",
    schedule_interval=None,
    catchup=False
)

sellers_gcs= PostgresToGCSOperator(
    task_id = "sellers_data_postgres_to_gcs",
    sql = f'select * from {PG_SCHEMA}.{PG_TABLE9};',
    bucket = BQ_BUCKET,
    filename = FILENAME9,
    export_format = "CSV",
    postgres_conn_id = PG_CONN_ID,
    field_delimiter = ',',
    gzip = False,
    task_concurrency = 1,
    gcp_conn_id = CONN_ID,
    dag=dag
)

sellers_bq = GCSToBigQueryOperator(
    task_id = "Load_Sellers_data_to_bq",
    bucket = BQ_BUCKET,
    source_objects = [FILENAME9],
    destination_project_dataset_table = f'{BQ_PROJECT}.{BQ_DATASET}.{BQ_TABLE9}',
    schema_object= SCHEMA_OBJ9,
    create_disposition = "CREATE_IF_NEEDED",
    write_disposition="WRITE_TRUNCATE",
     gcp_conn_id=CONN_ID,
    dag=dag,
)

sellers_gcs >> sellers_bq