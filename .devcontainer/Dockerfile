FROM mcr.microsoft.com/devcontainers/base:bookworm

# Major PostgreSQL version (installed from the official PGDG apt repository)
ARG PG_VERSION=16

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql-common ca-certificates \
    # do not auto-create a system-wide "main" cluster; we create a user-owned one on start
    && sed -i 's/^#\?create_main_cluster.*/create_main_cluster = false/' /etc/postgresql-common/createcluster.conf \
    && /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y \
    && apt-get install -y --no-install-recommends \
        postgresql-${PG_VERSION} \
        postgresql-client-${PG_VERSION} \
        postgresql-contrib \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PG_VERSION=${PG_VERSION}
ENV PATH="/usr/lib/postgresql/${PG_VERSION}/bin:${PATH}"

# Data directory owned by the dev user (mounted as a named volume in devcontainer.json)
RUN mkdir -p /home/vscode/pgdata && chown vscode:vscode /home/vscode/pgdata \
    && chmod 700 /home/vscode/pgdata
