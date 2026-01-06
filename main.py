import psycopg2
import json
from api_request.lucca_api import fetch_data
from datetime import datetime

def insert_users(users):
    """Insère ou met à jour les utilisateurs dans la table Postgres"""
    conn = psycopg2.connect(
        host="localhost",
        port="5433",  # ton port Docker
        dbname="lucca_db",
        user="lucca_user",
        password="lucca_pass"
    )
    cur = conn.cursor()

    # Crée la table si elle n'existe pas
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
                user.get("firstName"),  # <-- changement ici
                user.get("lastName"),   # <-- et ici
                user.get("mail"),
                user.get("employeeNumber"),
                user.get("modifiedAt"),
                json.dumps(user),        # stocke tout le JSON complet
                datetime.utcnow()        # date/heure du dernier refresh
            )
        )

    conn.commit()
    cur.close()
    conn.close()
    print(f"✅ {len(users)} users inserted/updated successfully")

if __name__ == "__main__":
    # Récupère les données de l'API Lucca
    data = fetch_data()
    users = data.get("data", {}).get("items", [])  # liste des utilisateurs

    if not users:
        print("⚠️ No users found in API response")
    else:
        insert_users(users)
