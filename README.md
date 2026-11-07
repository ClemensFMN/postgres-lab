# postgres-lab

A devcontainer with a PostgreSQL server and the `psql` CLI for SQL testing.
It works in VS Code (Dev Containers) and in GitHub Codespaces.

## Usage

1. Open the repo in VS Code and choose **Reopen in Container**. In GitHub, use **Code → Codespaces → Create codespace**.
2. On every container start, `.devcontainer/start-postgres.sh` initializes the cluster if needed, starts the server and creates the database `lab`.
3. Open a terminal and run:

   ```bash
   psql                      # connects to db "lab" as user "postgres"
   psql -f sql/example.sql   # run a script
   ```

## Details

| Item | Value |
|------|-------|
| PostgreSQL version | 16 (change `PG_VERSION` in `.devcontainer/devcontainer.json`) |
| Host / port | `localhost:5432` (forwarded) |
| User / database | `postgres` / `lab` (no password, `trust` auth) |
| Data directory | `~/pgdata`, kept on the Docker volume `postgres-lab-pgdata` |
| Server log | `~/pgdata/server.log` |

The `PG*` environment variables are preset, so `psql` needs no arguments.

**Reset the database:** stop the server with `pg_ctl stop`, then delete the contents of `~/pgdata` and run `bash .devcontainer/start-postgres.sh`. You can also delete the Docker volume and rebuild.

> Trust authentication is for local development only. Don't expose this setup publicly.
