from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta
import sys
import json
import psycopg2

# Pour que Airflow trouve ton module api_request
sys.path.append("/opt/airflow")
from api_request.lucca_api import fetch_data
from datetime import datetime as dt

def fetch_and_insert():
    # Appel à l'API Lucca
    data = fetch_data()
    users = data.get("data", {}).get("items", [])
    if not users:
        print("⚠️ No users found in API response")
        return

    # Connexion à Postgres depuis Airflow (réseau Docker interne)
    conn = psycopg2.connect(
        host="postgres",  # nom du service Docker
        port="5432",      # port interne du container Postgres
        dbname="lucca_db",
        user="lucca_user",
        password="lucca_pass"
    )
    cur = conn.cursor()

    # Création automatique de la table si elle n'existe pas
    cur.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id VARCHAR PRIMARY KEY,
        first_name VARCHAR,
        last_name VARCHAR,
        mail VARCHAR,
        employee_number VARCHAR,
        modified_at TIMESTAMP,
        raw_payload JSONB,
        refreshed_at TIMESTAMP
    )
    """)

    # Insertion ou mise à jour des utilisateurs
    for user in users:
        cur.execute(
            """
            INSERT INTO users (id, first_name, last_name, mail, employee_number, modified_at, raw_payload, refreshed_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (id) DO UPDATE SET
                first_name = EXCLUDED.first_name,
                last_name = EXCLUDED.last_name,
                mail = EXCLUDED.mail,
                employee_number = EXCLUDED.employee_number,
                modified_at = EXCLUDED.modified_at,
                raw_payload = EXCLUDED.raw_payload,
                refreshed_at = EXCLUDED.refreshed_at
            """,
            (
                user["id"],
                user.get("firstName"),
                user.get("lastName"),
                user.get("mail"),
                user.get("employeeNumber"),
                user.get("modifiedAt"),
                json.dumps(user),
                dt.utcnow()  # date/heure UTC du refresh
            )
        )

    conn.commit()
    cur.close()
    conn.close()
    print(f"✅ {len(users)} users inserted/updated successfully")

# Arguments par défaut du DAG
default_args = {
    'owner': 'marc',
    'depends_on_past': False,
    'start_date': datetime(2026, 1, 3),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Définition du DAG
dag = DAG(
    'lucca_daily_update',  # dag_id
    default_args=default_args,
    schedule_interval='0 * * * *',  # toutes les heures à l'heure pile
    catchup=False
)

# Tâche principale
task_fetch_users = PythonOperator(
    task_id='fetch_and_insert_users',
    python_callable=fetch_and_insert,
    dag=dag
)
