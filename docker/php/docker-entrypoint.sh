#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
        set -- php-fpm "$@"
fi

if [ "$1" = 'php-fpm' ] || [ "$1" = 'php' ] || [ "$1" = 'bin/console' ]; then
        if [ -z "$(ls -A 'vendor/' 2>/dev/null)" ]; then
                composer install --prefer-dist --no-progress --no-interaction
        fi

        # Display information about the current project
        # Or about an error in project initialization
        php bin/console cache:clear --no-warmup || true
        php bin/console -V

        setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX var
        setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX var
        echo 'Archiraq is ready'
fi

exec docker-php-entrypoint "$@"
