#!/usr/bin/env bash

# Check if the 'heroku' command is available
if ! command -v heroku &> /dev/null; then
    echo "Error: 'heroku' command not found. Please make sure it's installed."
    exit 1
fi

# Check if required environment variables are set
if [ -z "$HEROKU_APP_NAME" ]; then
    echo "Error: HEROKU_APP_NAME environment variable must be set."
    exit 1
fi

if [ -z "$HEROKU_API_KEY" ]; then
    echo "Error: HEROKU_API_KEY environment variable must be set."
    exit 1
fi

# Decode Heroku API key for authentication
HEROKU_API_KEY_DECODED=$(echo "$HEROKU_API_KEY" | base64 --decode)

# Create .netrc file for Heroku API key
echo -e "machine api.heroku.com\n  login $HEROKU_API_KEY_DECODED" > ~/.netrc
chmod 600 ~/.netrc

# Fetch logs using Heroku API
echo "Fetching logs from Heroku for app: $HEROKU_APP_NAME..."
if ! heroku logs --app "$HEROKU_APP_NAME"; then
    echo "Error: Failed to fetch logs from Heroku for app: $HEROKU_APP_NAME."
    exit 1
fi
