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
    exit 1
fi

# Set the Heroku API key for authentication
echo -n "$HEROKU_API_KEY" | base64 --decode > ~/.netrc
chmod 600 ~/.netrc

# Fetch logs using Heroku API
echo "Fetching logs from Heroku..."
if ! heroku logs --app "$HEROKU_APP_NAME"; then
    echo "Error: Failed to fetch logs from Heroku."
    exit 1
fi