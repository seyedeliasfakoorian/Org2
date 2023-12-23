#!/bin/bash

# Print all environment variables for debugging
env

# Check if required environment variables are set
if [ -z "$HEROKU_APP_NAME" ]; then
    echo "Error: HEROKU_APP_NAME environment variable must be set."
    exit 1
fi

if [ -z "$HEROKU_API_KEY" ]; then
    echo "Error: HEROKU_API_KEY environment variable must be set."
    exit 1
fi

# Print the value of HEROKU_API_KEY for debugging
echo "HEROKU_API_KEY: $HEROKU_API_KEY"

# Set Heroku API key for authentication
HEROKU_API_KEY_DECODED=$(echo "$HEROKU_API_KEY" | base64 --decode)

# Extract email and password from API key using awk
HEROKU_EMAIL=$(echo "$HEROKU_API_KEY_DECODED" | awk -F: '{print $1}')
HEROKU_PASSWORD=$(echo "$HEROKU_API_KEY_DECODED" | awk -F: '{print $2}')

# Log in using Heroku API key
echo "Logging in to Heroku..."
if ! printf "%s\n%s\n" "$HEROKU_EMAIL" "$HEROKU_PASSWORD" | heroku login --interactive; then
    echo "Error: Heroku login failed."
    exit 1
else
    echo "Heroku login successful."
fi

# Fetch logs using Heroku API
echo "Fetching logs from Heroku..."
if ! heroku logs --app "$HEROKU_APP_NAME"; then
    echo "Error: Failed to fetch logs from Heroku."
    exit 1
fi
