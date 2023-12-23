#!/usr/bin/env bash

# Check if heroku command is available
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

# Log in using Heroku API key
echo "Logging in to Heroku..."
heroku auth:token > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Heroku login failed."
    exit 1
else
    echo "Heroku login successful."
fi

# Fetch logs using Heroku API
echo "Fetching logs from Heroku..."
heroku logs --app "$HEROKU_APP_NAME" > heroku_logs.txt 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch logs from Heroku. Check heroku_logs.txt for details."
    exit 1
else
    echo "Logs fetched successfully. Check heroku_logs.txt for details."
fi
