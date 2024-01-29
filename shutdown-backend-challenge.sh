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
  PROJECT_NAME="pysect-backend-challenge-dev"
elif [ "$ENVIRONMENT" == "prod" ]; then
  DOCKER_COMPOSE_FILE="docker-compose.prod.yml"
  PROJECT_NAME="pysect-backend-challenge-prod"
else
  echo "Error: Unknown environment. Supported values are dev or prod." >&2
  exit 1
fi

BASE_DIR="/home/pi/pysect-src"
PROJECT_DIR="$BASE_DIR/$PROJECT_NAME"

echo "Shutting down $PROJECT_NAME..."
cd "$PROJECT_DIR"
docker compose -f "$DOCKER_COMPOSE_FILE" down
wait

cd ..
echo "$PROJECT_NAME is off!"