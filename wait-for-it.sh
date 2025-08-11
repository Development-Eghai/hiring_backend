#!/usr/bin/env bash

host="$1"
port="$2"
shift 2
cmd="$@"

echo "🔄 Waiting for $host:$port to be ready..."

# Wait for DNS resolution and port availability
until getent hosts "$host" && nc -z "$host" "$port"; do
  echo "⏳ Still waiting for $host:$port..."
  sleep 2
done

echo "✅ $host:$port is available — launching Django"
exec $cmd