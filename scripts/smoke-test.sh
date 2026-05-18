#!/bin/bash
set -e

echo "Running smoke test..."

URL=${1:-http://localhost:8081}

for i in {1..10}; do
  echo "Attempt $i..."
  if curl -f "$URL" >/dev/null 2>&1; then
    echo "Smoke test passed"
    exit 0
  fi
  sleep 2
done

echo "Smoke test failed"
exit 1