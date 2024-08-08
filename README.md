# Project Overview

This project develops an end to end ETL process using Olist dataset from Kaggle to help data end users answer some analytical questions. The project used Postgresql, Docker, Docker Compose, Airflow, dbt and Bigquery in developing the pipepline.

![image](assets/project_setup.png)

## Project Steps

- 1. Data Ingestion into PostgreSQL
- 2. Setting up Apache Airflow and loading data from PostgreSQL to BigQuery
- 3. Transforming and Modeling Data with dbt
- 4. Answering Analytical Questions

## Step 1 : Data Ingestion into PostgreSQL

- 1. Download the Dataset:
  - Download the Brazilian E-Commerce dataset from Kaggle.
- 2. Setup PostgreSQL Database:
  - Setup Postgresql using Docker & Docker Compose.
  - Create a new database named ecommerce.
- 3. Create Tables:
  - Create tables in the PostgreSQL database corresponding to each CSV file in the dataset.
- 4. Ingest Data:
  - Ingest the data into the tables, this will serve as your source data

![image](assets/ecommerce_db.png)

## Step 2: Setting up Apache Airflow

- 1. Install Airflow:
  - Set up airflow with docker-compose
- 2. Create Airflow DAG:
  - Creation of Directed Acyclic Graph (DAG) in Airflow to orchestrate the ETL process.
  - The DAG tasks to:
    - Extract data from PostgreSQL.
    - Load data into Google Cloud Storage
    - Ingest data into Google BigQuery.
