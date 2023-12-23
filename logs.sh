#!/usr/bin/env bash

# Check if the 'heroku' command is available
if ! command -v heroku &> /dev/null; then
    echo "Error: 'heroku' command not found. Please make sure it's installed."
    exit 1
fi

# Print all environment variables for debugging
env

# Check if required environment variables are set
if [ -z "$HEROKU_APP_NAME" ]; then
    echo "Error: HEROKU_APP_NAME environment variable must be set."
    exit 1
fi

# Set Heroku API key for authentication
if [ -z "$HEROKU_API_KEY" ]; then
    echo "Error: HEROKU_API_KEY environment variable must be set."
    echo "Exiting without attempting Heroku login."
    exit 1
fi

# Attempt Heroku login
echo "Logging in to Heroku..."
HEROKU_LOGIN_OUTPUT=$(echo "$HEROKU_API_KEY" | base64 --decode | heroku login --interactive 2>&1)

# Check the exit code of heroku login
if [ $? -ne 0 ]; then
    echo "Error: Heroku login failed."
    echo "Heroku login output:"
    echo "$HEROKU_LOGIN_OUTPUT"
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