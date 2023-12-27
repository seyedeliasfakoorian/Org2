#!/usr/bin/env bash

# Check if the 'heroku' command is available
if ! command -v heroku &> /dev/null; then
    echo "Error: 'heroku' command not found. Please make sure it's installed."
    exit 1
fi

# Check if required environment variables are set
if [ -z "$secrets.HEROKU_APP_NAME" ]; then
    echo "Error: 'secrets.HEROKU_APP_NAME' environment variable must be set."
    exit 1
fi

if [ -z "$secrets.HEROKU_API_KEY" ]; then
    echo "Error: 'secrets.HEROKU_API_KEY' environment variable must be set."
    exit 1
fi

# Decode Heroku API key for authentication
HEROKU_API_KEY_DECODED=$(echo "$secrets.HEROKU_API_KEY" | base64 --decode)

# Login to Heroku with .netrc
echo -e "machine api.heroku.com\n  login $HEROKU_API_KEY_DECODED" > ~/.netrc
chmod 600 ~/.netrc

# Fetch logs using Heroku API
APP_NAME="$secrets.HEROKU_APP_NAME"
echo "Fetching logs from Heroku for app: $APP_NAME..."
if ! heroku logs --app "$APP_NAME"; then
    echo "Error: Failed to fetch logs from Heroku for app: $APP_NAME"
    exit 1
fi
