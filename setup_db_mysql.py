import os
import mysql.connector
from dotenv import load_dotenv
import subprocess

import env_resolver

# Load environment variables
env_resolver.load_env()

DB_PREFIX = os.environ.get("DB_PREFIX", "MYSQL")
DB_HOST = os.environ.get(f"{DB_PREFIX}_DB_HOST", os.environ["DATABASE_HOST"]) or os.environ["DB_HOST"]
DB_PORT = int(os.environ.get(f"{DB_PREFIX}_DB_PORT", os.environ["DATABASE_PORT"]) or os.environ["DB_PORT"])
DB_USER = os.environ.get(f"{DB_PREFIX}_DB_USER", os.environ["DATABASE_USER"]) or os.environ["DB_USER"]
DB_PASSWORD = os.environ.get(f"{DB_PREFIX}_DB_PASSWORD", os.environ["DATABASE_PASSWORD"]) or os.environ["DB_PASSWORD"]
DB_NAME = os.environ.get(f"{DB_PREFIX}_DB_NAME", os.environ["DATABASE_NAME"]) or os.environ["DB_NAME"]
DUMP_FILE = os.environ.get(f"{DB_PREFIX}_DUMP_FILE", os.environ["DUMP_FILE"]) or os.environ["DUMP_FILE"]

# Step 1: Create the database if it doesn't exist
try:
    conn = mysql.connector.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD
    )
    conn.autocommit = True
    cursor = conn.cursor()
    cursor.execute(f"CREATE DATABASE IF NOT EXISTS `{DB_NAME}`")
    print(f"Database `{DB_NAME}` ensured.")
except mysql.connector.Error as err:
    print(f"Error: {err}")
    exit(1)
finally:
    if conn.is_connected():
        cursor.close()
        conn.close()

# Step 2: Load the dump file using the `mysql` CLI
try:
    subprocess.run(
        [
            "mysql",
            f"-h{DB_HOST}",
            f"-P{DB_PORT}",
            f"-u{DB_USER}",
            f"-p{DB_PASSWORD}",
            DB_NAME
        ],
        input=open(DUMP_FILE, "rb").read(),
        check=True
    )
    print(f"Successfully imported `{DUMP_FILE}` into `{DB_NAME}`.")
except subprocess.CalledProcessError as e:
    print("Failed to import dump:", e)
