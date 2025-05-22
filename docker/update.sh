#!/usr/bin/env bash

DOCKER_COMPOSE_FILE="compose.yml"

# Fetch the latest PostgreSQL version from the API
POSTGRESQL=$(curl -s https://endoflife.date/api/postgresql.json)
PG_VERSION="postgres:$(echo "$POSTGRESQL" | jq -r '.[0].latest')-alpine"

# Extract the current version of PostgreSQL from the compose file
pg_current_version=$(grep -A 5 "postgres:" "$DOCKER_COMPOSE_FILE" | grep "image:" | awk '{print $2}')

# Debug: Show extracted versions
echo "🔍 Extracted from file: $pg_current_version"
echo "🔍 Fetched from API: $PG_VERSION"

# Compare the versions
if [ "$pg_current_version" != "$PG_VERSION" ]; then
  echo "🚀 Updating PostgreSQL version in $DOCKER_COMPOSE_FILE..."
  
  # Method 1: Safe sed replacement with backup
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (BSD sed)
    sed -i.bak "s|$pg_current_version|$PG_VERSION|g" compose.yml
  else
    # Linux (GNU sed)
    sed -i "s|postgres:[0-9]\+\.[0-9]\+-alpine|$PG_VERSION|g" "$DOCKER_COMPOSE_FILE"
  fi

  # Verify the change was applied
  if grep -q "$PG_VERSION" "$DOCKER_COMPOSE_FILE"; then
    echo "✅ PostgreSQL version successfully updated in $DOCKER_COMPOSE_FILE!"
  else
    echo "❌ ERROR: The replacement did not work. Check permissions or sed syntax."
  fi
else
  echo "✅ PostgreSQL is already at the latest version. No update needed."
fi
