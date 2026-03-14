# Floodplains2 - Dockerized Environment

This project provides a dockerized setup for the `floodplains2` ([archiraq](https://github.com/bnza/archiraq)) application, designed to mirror the production environment for development and testing.

## Separation of Concerns

The project is strictly divided into two parts:

1.  **Business Logic (`/repo`)**:
    *   Contains the application source code (Symfony/Vue.js).
    *   Standalone Git repository mirroring the production server.
    *   Changes here should be limited to business requirements.
2.  **Infrastructure & Environment (Project Root)**:
    *   Contains Docker configurations, orchestration files, and management scripts.
    *   Independent Git history managing the containerized environment.

## Tracked Infrastructure Structure

The following directories and files are part of the infrastructure version control:

*   `docker/`: Service-specific configurations and Dockerfiles.
    *   `database/`: Custom PostGIS 3.6.1 + PostgreSQL 15 build and initialization scripts.
    *   `geoserver/`: GeoServer 2.25.0 setup with dynamic security patching.
    *   `nginx/`: Reverse proxy configuration mirroring production's single-origin architecture.
    *   `php/`: PHP 7.2-fpm environment with custom entrypoints for dependency management.
    *   `node/`: Node 8 environment for asset compilation (Encore).
*   `bin/`: Management and synchronization scripts.
    *   `sync-geoserver-data.sh`: Script to replicate production data snapshots (untracked).
    *   `geoserver-migrate.sh`: Tracked REST API migrations for programmatic configuration changes.
*   `docker-compose.yml` & `docker-compose.override.yml`: Main orchestration files for production-like and development environments.
*   `.env.dist`: Template for environment-specific variables.

---
*Note: Sensitive production data (GeoServer configs, database dumps, imagery) is synchronized locally but is explicitly excluded from Git tracking to protect production secrets.*
