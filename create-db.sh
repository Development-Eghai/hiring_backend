#!/bin/bash

if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <container_name> <database_name> <new_username> [new_user_password]"
  exit 1
fi

CONTAINER_NAME=$1
DB_NAME=$2
NEW_USER=$3
NEW_USER_PASSWORD=${4:-$(openssl rand -base64 12)}

read -p "Enter admin database username (e.g. edgar): " ADMIN_USER
read -s -p "Enter password for admin user '$ADMIN_USER': " ADMIN_PASSWORD
echo

DEFAULT_DB=edgar_db
export PGPASSWORD="$ADMIN_PASSWORD"

echo "Creating user '$NEW_USER' in container '$CONTAINER_NAME'..."

# Step 1: Create user if not exists
docker exec -i "$CONTAINER_NAME" psql -U "$ADMIN_USER" -d "$DEFAULT_DB" -v ON_ERROR_STOP=1 <<EOF
DO \$\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_user WHERE usename = '$NEW_USER'
   ) THEN
      CREATE USER $NEW_USER WITH PASSWORD '$NEW_USER_PASSWORD';
   END IF;
END
\$\$;
EOF

USER_RESULT=$?

# Step 2: Check if database exists
DB_EXISTS=$(docker exec -i "$CONTAINER_NAME" psql -U "$ADMIN_USER" -d "$DEFAULT_DB" -tAc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';")

if [ "$DB_EXISTS" != "1" ]; then
  echo "Creating database '$DB_NAME' owned by '$NEW_USER'..."
  docker exec -i "$CONTAINER_NAME" psql -U "$ADMIN_USER" -d "$DEFAULT_DB" -c "CREATE DATABASE $DB_NAME OWNER $NEW_USER;"
  DB_RESULT=$?
else
  echo "Database '$DB_NAME' already exists."
  DB_RESULT=0
fi

unset PGPASSWORD

if [ $USER_RESULT -eq 0 ] && [ $DB_RESULT -eq 0 ]; then
  echo "✅ Success: user '$NEW_USER' and database '$DB_NAME' are ready."
  echo "🔐 Password for '$NEW_USER': $NEW_USER_PASSWORD"
else
  echo "❌ Failed to create user or database. Check logs and credentials."
  exit 1
fi
