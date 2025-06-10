#!/usr/bin/env bash
# wait-for-it.sh
set -e

TIMEOUT=60
HOST="$1"
PORT="$2"
shift 2
CMD="$@"

for ((i=0;i<TIMEOUT;i++)); do
    nc -z "$HOST" "$PORT" && break
    sleep 1
done

exec $CMD