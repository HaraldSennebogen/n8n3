FROM n8nio/n8n:latest

# ---- Systempakete ----
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends imagemagick ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# n8n-User-Home vorbereiten (hier liegen Community-Packages)
RUN mkdir -p /home/node/.n8n \
 && chown -R node:node /home/node/.n8n

# ---- Community Nodes vorinstallieren ----
USER node
WORKDIR /home/node/.n8n
# package.json anlegen, falls nicht vorhanden
RUN [ -f package.json ] || printf '{ "name":"n8n-user","private":true,"dependencies":{} }' > package.json
# Google Search Console Node (Version ggf. anpassen)
RUN npm install n8n-nodes-google-search-console@1.0.33

# Community Packages aktivieren (praktisch auf Railway)
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
# Optional: fehlende Packages beim Start automatisch (re)installieren
ENV N8N_REINSTALL_MISSING_PACKAGES=true

# ---- Deine bisherigen ARG/ENV ----
ARG PGPASSWORD
ARG PGHOST
ARG PGPORT
ARG PGDATABASE
ARG PGUSER

ENV DB_TYPE=postgresdb \
    DB_POSTGRESDB_DATABASE=$PGDATABASE \
    DB_POSTGRESDB_HOST=$PGHOST \
    DB_POSTGRESDB_PORT=$PGPORT \
    DB_POSTGRESDB_USER=$PGUSER \
    DB_POSTGRESDB_PASSWORD=$PGPASSWORD

ARG ENCRYPTION_KEY
ENV N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY

CMD ["n8n", "start"]
