#!/bin/sh

# Startup code for express server used by the docker-compose.
npm start
readonly cmd="$*"
exec $cmd
