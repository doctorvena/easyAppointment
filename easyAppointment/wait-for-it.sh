#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

until nc -zv $host 1433; do
  >&2 echo "SQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "SQL is up - executing command"
exec $cmd
