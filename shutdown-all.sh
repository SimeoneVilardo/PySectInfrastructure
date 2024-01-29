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

INFRASTRUCTURE_PATH=$(pwd)

source "$INFRASTRUCTURE_PATH/shutdown-backend-challenge.sh" -env "$ENVIRONMENT"
source "$INFRASTRUCTURE_PATH//shutdown-backend-notification.sh" -env "$ENVIRONMENT"
source "$INFRASTRUCTURE_PATH//shutdown-frontend.sh" -env "$ENVIRONMENT"

echo "All systems are down!"