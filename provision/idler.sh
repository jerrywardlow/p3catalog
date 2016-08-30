#!/bin/sh

set -e

until psql -h "postgres" -U "pgdbuser" -d "itemcatalog" -c '\l'; do
    >&2 echo "Waiting on postgres..."
    sleep 1
done

>&2 echo "Postgres up, gun time!"
gunicorn -b 0.0.0.0:5000 wsgi:app
