ARG POSTGRES_VERSION=15
FROM postgres:${POSTGRES_VERSION}-alpine

# PostGIS version required
ARG POSTGIS_VERSION=3.6.1

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        postgresql-dev \
        perl \
        make \
        gcc \
        g++ \
        libxml2-dev \
        geos-dev \
        proj-dev \
        gdal-dev \
        json-c-dev \
        protobuf-c-dev \
        clang19-dev \
        llvm19-dev \
    && apk add --no-cache \
        geos \
        proj \
        gdal \
        json-c \
        protobuf-c \
    && wget -O postgis.tar.gz "https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz" \
    && mkdir -p /usr/src/postgis \
    && tar -xzf postgis.tar.gz -C /usr/src/postgis --strip-components=1 \
    && rm postgis.tar.gz \
    && cd /usr/src/postgis \
    && ./configure \
    && make -j "$(nproc)" \
    && make install \
    && cd / \
    && rm -rf /usr/src/postgis \
    && apk del .build-deps

# Add healthcheck
HEALTHCHECK --interval=5s --timeout=5s --retries=5 \
    CMD ["pg_isready", "-U", "${POSTGRES_USER:-app}"]
