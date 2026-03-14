#!/bin/bash

# Load environment variables from .env if it exists
if [ -f .env ]; then
    while IFS='=' read -r key value || [ -n "$key" ]; do
        key=$(echo "$key" | tr -d '\r')
        value=$(echo "$value" | tr -d '\r')
        case "$key" in '#'*) continue ;; esac
        [ -n "$key" ] && export "$key=$value"
    done < .env
fi

# Configuration
GEOSERVER_HOST="${GEOSERVER_HOST:-localhost}"
GEOSERVER_PORT="${GEOSERVER_PORT:-8080}"
GEOSERVER_USER="${GEOSERVER_ADMIN_USER:-admin}"
GEOSERVER_PASS="${GEOSERVER_ADMIN_PASSWORD:-geoserver}"
BASE_URL="http://$GEOSERVER_HOST:$GEOSERVER_PORT/geoserver/rest"

echo "Using GeoServer at $BASE_URL"

# Helper function for REST calls
gs_curl() {
    local method=$1
    local endpoint=$2
    local data=$3
    local content_type="${4:-application/xml}"

    if [ -n "$data" ]; then
        curl -s -u "$GEOSERVER_USER:$GEOSERVER_PASS" -X "$method" \
            -H "Content-type: $content_type" \
            -d "$data" \
            "$BASE_URL/$endpoint"
    else
        curl -s -u "$GEOSERVER_USER:$GEOSERVER_PASS" -X "$method" \
            "$BASE_URL/$endpoint"
    fi
}

# --- Example Migrations ---

# 1. Create a workspace (if not exists)
# echo "Creating workspace 'archiraq'..."
# gs_curl "POST" "workspaces" "<workspace><name>archiraq</name></workspace>"

# 2. Update a DataStore connection string
# echo "Updating DataStore 'archiraq'..."
# gs_curl "PUT" "workspaces/archiraq/datastores/archiraq" \
#   "<dataStore><connectionParameters><host>database</host></connectionParameters></dataStore>"

echo "GeoServer migration completed."
