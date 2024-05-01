#!/bin/bash

while [ "$#" -gt 0 ]; do
  case "$1" in
    -env)
      if [ -n "$2" ]; then
        ENVIRONMENT="$2"
        shift
      else
        echo "Error: -env requires a valid environment (dev or prod)" >&2
        exit 1
      fi
      ;;
    *)
      echo "Error: Unknown option: $1" >&2
      exit 1
      ;;
  esac
  shift
done

if [ -z "$ENVIRONMENT" ]; then
  echo "Error: Please provide the environment using -env option (dev or prod)" >&2
  exit 1
fi

if [ "$ENVIRONMENT" == "dev" ]; then
  DOCKER_COMPOSE_FILE="docker-compose.dev.yml"
  WEB_CONTAINER="web-dev"
elif [ "$ENVIRONMENT" == "prod" ]; then
  DOCKER_COMPOSE_FILE="docker-compose.prod.yml"
  WEB_CONTAINER="web-prod"
else
  echo "Error: Unknown environment. Supported values are dev or prod." >&2
  exit 1
fi

BASE_DIR="/home/pi/pysect-infrastructure"
DOCKER_COMPOSE_FILE="backend-challenge/$DOCKER_COMPOSE_FILE"
cd "$BASE_DIR"

echo "Deploying to $ENVIRONMENT..."
echo "Shutting down containers..."
docker compose -f "$DOCKER_COMPOSE_FILE" down
wait

echo "Starting new containers..."
docker compose -f "$DOCKER_COMPOSE_FILE" up --build -d
wait

echo "Doing migrations..."
docker compose -f "$DOCKER_COMPOSE_FILE" exec "$WEB_CONTAINER" python manage.py migrate
wait

if [ "$ENVIRONMENT" == "dev" ]; then
  echo "Installing fixtures..."
  docker compose -f "$DOCKER_COMPOSE_FILE" exec "$WEB_CONTAINER" python manage.py loaddata server/fixtures/*.json
  wait
fi

echo "Up and running!"