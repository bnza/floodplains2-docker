ARG GEOSERVER_VERSION=2.25.0
FROM docker.osgeo.org/geoserver:${GEOSERVER_VERSION}

# Copy GeoServer configuration snapshot into the image
# This replaces the need for a bound volume for the configuration
COPY data/ /data/archiraq/geoserver/2.15/

COPY init-security.sh /opt/init-security.sh
RUN chmod +x /opt/init-security.sh

ENTRYPOINT ["bash", "/opt/init-security.sh"]
