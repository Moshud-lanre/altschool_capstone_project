from airflow import DAG
from airflow.providers.google.cloud.transfers.postgres_to_gcs import PostgresToGCSOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from datetime import datetime, timedelta
from airflow.models import Variable


BQ_BUCKET = Variable.get("BQ_BUCKET")
SCHEMA_OBJ2 = Variable.get("SCHEMA_OBJ2")
PG_SCHEMA = Variable.get("PG_SCHEMA")
PG_TABLE2 = Variable.get("PG_TABLE2")
CONN_ID = Variable.get("CONN_ID")
FILENAME2 = Variable.get("filename2")
PG_CONN_ID = Variable.get("PG_CONN_ID")
BQ_PROJECT = Variable.get("BQ_PROJECT")
BQ_DATASET = Variable.get("BQ_DATASET")
BQ_TABLE2 = Variable.get("BQ_TABLE2")





default_args = {
   'owner': 'Olanrewaju Moshood',
   'depends_on': False,
   'email_on_failure': False,
   'email_on_retry':False,
   'start_date': datetime(2024, 8, 14),
   'retries': 1,
   'retry_delay': timedelta(minutes=1) 
}

dag = DAG(
    "postgres_bq_etl",
    default_args=default_args,
    description="A dag to load data from pstgres to bigquery",
    schedule_interval=None,
    catchup=False
)

cat_gcs = PostgresToGCSOperator(
    task_id = "postgres_to_gcs",
    sql = f'select * from {PG_SCHEMA}.{PG_TABLE2};',
    bucket = BQ_BUCKET,
    filename = FILENAME2,
    export_format = "CSV",
    postgres_conn_id = PG_CONN_ID,
    field_delimiter = ',',
    gzip = True,
    task_concurrency = 1,
    gcp_conn_id = CONN_ID,
    dag=dag
)

cat_bq = GCSToBigQueryOperator(
    task_id = "Load_Customer_data_to_bq",
    bucket = BQ_BUCKET,
    source_objects = [FILENAME2],
    destination_project_dataset_table = f'{BQ_PROJECT}.{BQ_DATASET}.{BQ_TABLE2}',
    schema_object= SCHEMA_OBJ2,
    create_disposition = "CREATE_IF_NEEDED",
    write_disposition="WRITE_TRUNCATE",
    skip_leading_rows = 1,
     gcp_conn_id=CONN_ID,
    dag=dag,
)

cat_gcs >> cat_bq