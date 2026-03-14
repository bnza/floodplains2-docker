#!/bin/bash

# Load environment variables from .env if it exists
if [ -f .env ]; then
    # Parse .env file, removing comments and handling Windows CRLF if present
    # Using a POSIX-compliant method for env loading
    while IFS='=' read -r key value || [ -n "$key" ]; do
        # Strip trailing \r if present (from Windows CRLF)
        key=$(echo "$key" | tr -d '\r')
        value=$(echo "$value" | tr -d '\r')
        
        # Skip comments and empty lines
        case "$key" in
            '#'*|"") continue ;;
        esac
        
        # Trim leading/trailing whitespace
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        
        # Export the variable
        if [ -n "$key" ]; then
            export "$key=$value"
        fi
    done < .env
fi

# Configuration
REMOTE_USER="${REMOTE_USER:-user}"
REMOTE_HOST="${REMOTE_HOST:-archiraq.prod}"
REMOTE_BASE_PATH="${REMOTE_BASE_PATH:-/data/archiraq}"
SSH_KEY_PATH="${SSH_KEY_PATH:-}"
LOCAL_CORONA_PATH="${CORONA_DATA_DIR:-}"
LOCAL_SURVEY_PATH="${SURVEY_DATA_DIR:-}"

# SSH options
SSH_OPTS="ssh"
if [ -n "$SSH_KEY_PATH" ]; then
    SSH_OPTS="ssh -i $SSH_KEY_PATH"
fi

# Local paths (Hardcoded to match docker-compose.yml)
LOCAL_GEOSERVER_PATH="./docker/geoserver/data"

# Ensure local directories exist
mkdir -p "$LOCAL_GEOSERVER_PATH" "$LOCAL_CORONA_PATH" "$LOCAL_SURVEY_PATH"

echo "Syncing data from $REMOTE_HOST:$REMOTE_BASE_PATH to $LOCAL_GEOSERVER_PATH ..."

# Sync Geoserver Data (Mirroring /data/archiraq/geoserver/2.15)
echo "Syncing Geoserver 2.15 data..."
rsync -avz --delete -e "$SSH_OPTS" \
    --exclude='logs/*' \
    --exclude='temp/*' \
    --exclude='tmp/*' \
    --exclude='gwc/*' \
    --include='gwc/*.xml' \
    "$REMOTE_USER@$REMOTE_HOST:$REMOTE_BASE_PATH/geoserver/2.15/" "$LOCAL_GEOSERVER_PATH/"

# Sync Corona Data
echo "Syncing Corona data to $LOCAL_CORONA_PATH..."
rsync -avz --delete -e "$SSH_OPTS" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_BASE_PATH/corona/" "$LOCAL_CORONA_PATH/"

# Sync Survey Data
echo "Syncing Survey data to $LOCAL_SURVEY_PATH..."
rsync -avz --delete -e "$SSH_OPTS" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_BASE_PATH/survey/" "$LOCAL_SURVEY_PATH/"

echo "Sync completed successfully."
