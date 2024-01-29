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
  BACKEND_CHALLENGE_PROJECT_NAME="pysect-backend-challenge-dev"
  BACKEND_NOTIFICATION_PROJECT_NAME="pysect-backend-notification-dev"
  FRONTEND_PROJECT_NAME="pysect-frontend-dev"
elif [ "$ENVIRONMENT" == "prod" ]; then
  DOCKER_COMPOSE_FILE="docker-compose.prod.yml"
  BACKEND_CHALLENGE_PROJECT_NAME="pysect-backend-challenge-prod"
  BACKEND_NOTIFICATION_PROJECT_NAME="pysect-backend-notification-prod"
  FRONTEND_PROJECT_NAME="pysect-frontend-prod"
else
  echo "Error: Unknown environment. Supported values are dev or prod." >&2
  exit 1
fi

BASE_DIR="/home/pi/pysect-src"
BACKEND_CHALLENGE_PROJECT_DIR="$BASE_DIR/$BACKEND_CHALLENGE_PROJECT_NAME"
BACKEND_NOTIFICATION_PROJECT_DIR="$BASE_DIR/$BACKEND_NOTIFICATION_PROJECT_NAME"
FRONTEND_PROJECT_DIR="$BASE_DIR/$FRONTEND_PROJECT_NAME"

echo "Shutting down $ENVIRONMENT..."

cd "$BACKEND_CHALLENGE_PROJECT_DIR"
echo "Shutting down backend challenge containers..."
docker compose -f "$DOCKER_COMPOSE_FILE" down
wait

cd "$BACKEND_NOTIFICATION_PROJECT_DIR"
echo "Shutting down backend notification containers..."
docker compose -f "$DOCKER_COMPOSE_FILE" down
wait

cd "$FRONTEND_PROJECT_DIR"
echo "Shutting down frontend containers..."
docker compose -f "$DOCKER_COMPOSE_FILE" down
wait

echo "All systems are off!"