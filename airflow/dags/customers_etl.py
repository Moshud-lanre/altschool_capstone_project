from airflow import DAG
from airflow.providers.google.cloud.transfers.postgres_to_gcs import PostgresToGCSOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from datetime import datetime, timedelta
from airflow.models import Variable


BQ_BUCKET = Variable.get("BQ_BUCKET")
SCHEMA_OBJ1 = Variable.get("SCHEMA_OBJ1")
PG_SCHEMA = Variable.get("PG_SCHEMA")
CONN_ID = Variable.get("CONN_ID")
FILENAME1 = Variable.get("filename1")
PG_CONN_ID = Variable.get("PG_CONN_ID")
BQ_PROJECT = Variable.get("BQ_PROJECT")
BQ_DATASET = Variable.get("BQ_DATASET")
BQ_TABLE1 = Variable.get("BQ_TABLE1")





default_args = {
   'owner': 'Olanrewaju Moshood',
   'depends_on': False,
   'email_on_failure': False,
   'email_on_retry':False,
   'start_date': datetime(2024, 8, 11),
   'retries': 1,
   'retry_delay': timedelta(minutes=1) 
}

dag = DAG(
    "customers_etl",
    default_args=default_args,
    description="A dag to load data from pstgres to bigquery",
    schedule_interval=None,
    catchup=False
)

customers_gcs = PostgresToGCSOperator(
    task_id = "postgres_to_gcs",
    sql = f'select * from {PG_SCHEMA}.{BQ_TABLE1};',
    bucket = BQ_BUCKET,
    filename = FILENAME1,
    export_format = "CSV",
    postgres_conn_id = PG_CONN_ID,
    field_delimiter = ',',
    gzip = False,
    task_concurrency = 1,
    gcp_conn_id = CONN_ID,
    dag=dag
)

customers_bq = GCSToBigQueryOperator(
    task_id = "Load_Customer_data_to_bq",
    bucket = BQ_BUCKET,
    source_objects = [FILENAME1],
    destination_project_dataset_table = f'{BQ_PROJECT}.{BQ_DATASET}.{BQ_TABLE1}',
    schema_object= SCHEMA_OBJ1,
    create_disposition = "CREATE_IF_NEEDED",
    write_disposition="WRITE_TRUNCATE",
     gcp_conn_id=CONN_ID,
    dag=dag,
)

customers_gcs >> customers_bq

#deserialize_json=True

# Todo
# 1. Run the terraform script,
# Set up variable in airflow 
# 2. Finish up the other 8 loading

