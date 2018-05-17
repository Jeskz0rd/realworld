#!/bin/sh

DATABASE_URL="postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_SERVICE_PORT}/${DB_NAME}"
# Check and wait until Postgres is ready
while ! pg_isready --dbname=$DB_NAME --host=$DB_HOST --username=$DB_USER --port=$DB_SERVICE_PORT --quiet
do
  echo "$(date) - waiting for database to start"
  sleep 3
done

echo "You selected $MIX_ENV as environment" 
echo "You selected $PORT as environment port"

#  In case it doesn't exist create and migrate database
if [[ -z `psql -Atqc "\\list $DB_NAME"` ]]; then
  echo "Database $DB_NAME does not exist. Creating..."
  mix ecto.create
  echo "Database $DB_NAME has been created."
  mix ecto.migrate
  echo "Database $DB_NAME has been migrated."
fi
echo "Running tests over $DB_NAME ..."
mix test
sleep 1
echo "Running application server ..."
mix phx.server
