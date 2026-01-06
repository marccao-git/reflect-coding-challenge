import os
import requests
from dotenv import load_dotenv
load_dotenv() 
# Récupération de la clé API depuis les variables d'environnement
API_KEY = os.getenv("LUCCA_API_KEY")

if not API_KEY:
    raise RuntimeError(
        "LUCCA_API_KEY environment variable is not set. "
        "Please define it in a .env file or your environment."
    )

api_url = (
    "https://reflect2-sandbox.ilucca-demo.net/api/v3/users?"
    "formerEmployees=true&fields="
    "id%2CfirstName%2ClastName%2CmodifiedAt%2Cmail%2CdtContractStart%2CdtContractEnd%2CbirthDate%2C"
    "employeeNumber%2Ccalendar.id%2Ccalendar.name%2Cculture.id%2Cculture.name%2C"
    "legalEntity.id%2ClegalEntity.name%2Cmanager.id%2Cmanager.name%2C"
    "rolePrincipal.id%2CrolePrincipal.name%2ChabilitedRoles.id%2ChabilitedRoles.name%2C"
    "userWorkCycles.id%2CuserWorkCycles.ownerID%2CuserWorkCycles.workCycleID%2C"
    "userWorkCycles.startsOn%2CuserWorkCycles.endsOn%2C"
    "department.id%2Cdepartment.name"
)

headers = {
    "Authorization": f"lucca application={API_KEY}"
}

def fetch_data():
    print("Fetching Lucca data from API...")
    try:
        response = requests.get(api_url, headers=headers)
        response.raise_for_status()
        print("API response received successfully.")
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
        raise


if __name__ == "__main__":
    data = fetch_data()
    print(data)
