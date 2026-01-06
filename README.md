# Reflect Coding Challenge – Setup Guide (Windows & macOS)

Ce projet utilise **PostgreSQL**, **Apache Airflow** et **dbt**.

PostgreSQL sert de base de données centrale pour stocker les données et les tables transformées.
Apache Airflow permet d’orchestrer et de planifier les pipelines afin de rafraîchir les données automatiquement (toutes les X heures / jours ou à la demande).
dbt est utilisé pour transformer les données et matérialiser des marts analytiques prêts pour l’analyse et le dashboarding.
L’ensemble permet de disposer de données fiables, à jour et exploitables via une architecture data moderne.

Ce README décrit **toutes les étapes nécessaires après le clonage du dépôt**, aussi bien sur **Windows** que sur **macOS**.

---

## 🧰 Prérequis

### Commun

* **Git**
* **Docker** & **Docker Compose**
* **Python 3.9.x ou 3.11.x 

---

## 📥 1. Cloner le projet

```bash
git clone https://github.com/marccao-git/reflect-coding-challenge.git
cd reflect-coding-challenge
```

---

## 🐍 2. Créer et activer l’environnement virtuel Python

### Windows (PowerShell)

```powershell
python -m venv .venv

# Autoriser l’exécution des scripts (une seule fois)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Activer le venv
.\.venv\Scripts\Activate.ps1
```

### macOS / Linux

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Vérification :

```bash
python --version
```

---

## 📦 3. Installer les dépendances Python

```bash
pip install --upgrade pip
pip install -r requirements.txt
```
---

## 4. Modifier le fichier .env pour la clé API Lucca

Dans le fichier .env, ajouter ou modifier la variable LUCCA_API_KEY avec votre propre clé API Lucca :
LUCCA_API_KEY=VOTRE_CLE_API_ICI
⚠️ Cette clé est personnelle, ne la partagez pas publiquement.

---

## 🐘 5. Base de données PostgreSQL (Docker)

Le projet utilise **une seule instance PostgreSQL** avec **deux bases** :

* `lucca_db` → données applicatives
* `airflow_db` → métadonnées Airflow

### Lancer PostgreSQL + Airflow

```bash
docker compose up -d
```

Vérifier que les conteneurs tournent :

```bash
docker ps
```

---

## 🗄️ 6. Créer la base Airflow (si nécessaire)

⚠️ À faire **uniquement si Airflow affiche une erreur `database "airflow_db" does not exist`**

```bash
docker compose exec postgres psql -U lucca_user -d lucca_db -c "CREATE DATABASE airflow_db;"
```

Puis redémarrer Airflow :

```bash
docker compose restart airflow
```

---

## 👤 7. Créer l’utilisateur Airflow

### Commande (Windows & macOS)

```bash
docker compose exec airflow airflow users create \
  --username admin \
  --firstname Marc \
  --lastname Marc \
  --role Admin \
  --email marc@example.com \
  --password admin
```

### Accès UI

* URL : [http://localhost:8080](http://localhost:8080)
* Login : `admin`
* Mot de passe : `admin`

---

## 🔁 8. Lancer dbt

Aller dans le dossier dbt :

```bash
cd dbt
```

### Vérifier dbt

```bash
dbt --version
```

### Lancer les marts

```bash
dbt run
```

👉 Les **marts** sont matérialisés dans PostgreSQL.

---

## 🛠️ Dépannage courant

### ❌ dbt crash / erreur étrange

➡️ Vérifier la version Python

```bash
python --version
```

Doit être **3.9.x ou 3.11.x**

---

### ❌ Airflow login impossible

➡️ Vérifier que l’utilisateur existe :

```bash
docker compose exec airflow airflow users list
```
---

## ✅ Résumé rapide

1. Créer le venv
2. Installer les requirements/modifier le .env
3. `docker compose up -d`
4. Créer `airflow_db` si besoin
5. Créer l’utilisateur Airflow
6. Se connecter à Airflow 
7. `dbt run`
