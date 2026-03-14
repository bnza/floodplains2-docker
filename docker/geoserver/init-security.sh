#!/bin/bash
SECURITY_DIR="${GEOSERVER_DATA_DIR}/security"
DEFAULT_SECURITY_DIR="${CATALINA_HOME}/webapps/geoserver/data/security"

# Skip credential update on subsequent starts to avoid unnecessary webapp reload.
# This also protects production credentials from being overwritten by .env defaults.
# Since the whole security folder is mirrored from production, we skip the update if it exists.
if [ -f "${SECURITY_DIR}/usergroup/default/users.xml" ]; then
    echo "Security directory exists. Skipping admin credential update."
    unset GEOSERVER_ADMIN_USER
    unset GEOSERVER_ADMIN_PASSWORD
fi

# Fix JDBC connection strings (localhost -> database)
# Patches both security JDBC configs and workspace datastore connection parameters.
echo "Correcting JDBC hostnames in data directory..."
find "${GEOSERVER_DATA_DIR}" -name "*.xml" -exec grep -l 'localhost' {} + 2>/dev/null | while read -r f; do
    sed -i 's/localhost:5432/database:5432/g' "$f"
    sed -i 's/>localhost</>database</g' "$f"
done

# Correct the proxy base URL in global.xml if it exists
if [ -f "${GEOSERVER_DATA_DIR}/global.xml" ]; then
    echo "Patching global.xml proxyBaseUrl..."
    # Replace the existing proxyBaseUrl with the docker environment value
    # Use | as delimiter for sed to handle slashes in URLs safely
    sed -i "s|<proxyBaseUrl>.*</proxyBaseUrl>|<proxyBaseUrl>http://localhost:${NGINX_PORT:-8000}/geoserver/</proxyBaseUrl>|g" "${GEOSERVER_DATA_DIR}/global.xml"
fi

# Allow anonymous READ access to WFS GetFeature for legacy compatibility
#if [ -f "${SECURITY_DIR}/services.properties" ]; then
#    echo "Patching services.properties to allow anonymous WFS GetFeature..."
#    sed -i 's/^wfs.GetFeature=.*/wfs.GetFeature=*/g' "${SECURITY_DIR}/services.properties"
#fi


exec /opt/startup.sh "$@"
