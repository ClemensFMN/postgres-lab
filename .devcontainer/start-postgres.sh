#!/usr/bin/env bash
# Initializes (first run only) and starts the PostgreSQL server inside the devcontainer.
# Development use only: local connections use "trust" authentication.
set -euo pipefail

PGDATA="${PGDATA:-$HOME/pgdata}"
PGPORT="${PGPORT:-5432}"
DB_NAME="${PGDATABASE:-lab}"
LOG_FILE="$PGDATA/server.log"

if [ ! -s "$PGDATA/PG_VERSION" ]; then
  echo ">> Initializing new PostgreSQL cluster in $PGDATA"
  initdb --username=postgres --auth=trust --encoding=UTF8 -D "$PGDATA" >/dev/null
fi

if pg_ctl -D "$PGDATA" status >/dev/null 2>&1; then
  echo ">> PostgreSQL already running"
else
  echo ">> Starting PostgreSQL"
  # unix socket in /tmp so no root-owned directory is needed
  pg_ctl -D "$PGDATA" -l "$LOG_FILE" -w \
    -o "-c listen_addresses=localhost -c port=$PGPORT -c unix_socket_directories=/tmp" start
fi

if ! pg_isready -q -h localhost -p "$PGPORT"; then
  echo "PostgreSQL did not become ready, see $LOG_FILE" >&2
  exit 1
fi

if ! psql -h localhost -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" | grep -q 1; then
  echo ">> Creating database '$DB_NAME'"
  createdb -h localhost "$DB_NAME"
fi

echo ">> PostgreSQL is ready. Connect with: psql   (database '$DB_NAME', user 'postgres')"
