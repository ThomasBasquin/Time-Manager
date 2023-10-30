#!/bin/bash
# Docker entrypoint script.

export PGPASSWORD=${DBPASSWORD}

# Wait until Postgres is ready
echo "Testing if Postgres is accepting connections. ${DBHOST} ${DBPORT} ${DBUSER}"
while ! pg_isready -q -h $DBHOST -p $DBPORT -U $DBUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $DBDATABASE" -h $DBHOST -p $DBPORT -U $DBUSER` ]]; then
  echo "Database $DBDATABASE does not exist. Creating..."
  MIX_ENV=prod mix ecto.create
  MIX_ENV=prod mix ecto.migrate
  MIX_ENV=prod mix run priv/repo/seeds.exs
  echo "Database $DBDATABASE created."
fi

export MIX_ENV=prod
exec mix phx.server
