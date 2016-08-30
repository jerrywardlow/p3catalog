#!/bin/bash

set -e

cmd="$1"

until psql -h "postgres" -U "postgres" -c '\l'; do
    >&2 echo "Waiting on postgres..."
    sleep 1
done

>&2 echo "Postgres up, gun time!"
exec cmd
