#!/bin/bash

# Check if the 'heroku' command is available
if [ ! "$(which heroku)" ]; then
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
HEROKU_API_KEY_DECODED=$(echo "$HEROKU_API_KEY" | base64 -d)

# Create .netrc file for Heroku API key
echo -e "machine api.heroku.com\n  login $HEROKU_API_KEY_DECODED" > ~/.netrc
chmod 600 ~/.netrc

# Fetch logs using Heroku API
echo "Fetching logs from Heroku for app: website-breaker-demo..."
if ! heroku logs --app website-breaker-demo; then
    echo "Error: Failed to fetch logs from Heroku for app: website-breaker-demo"
    exit 1
fi
