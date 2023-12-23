#!/usr/bin/env bash

# Check if heroku command is available
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

if [ -z "$HEROKU_API_KEY" ]; then
    echo "Error: HEROKU_API_KEY environment variable must be set."
    exit 1
fi

# Print the values of HEROKU_APP_NAME and HEROKU_API_KEY for debugging
echo "HEROKU_APP_NAME: $HEROKU_APP_NAME"
echo "HEROKU_API_KEY: $HEROKU_API_KEY"

# Decode Heroku API key
HEROKU_API_KEY_DECODED=$(echo "$HEROKU_API_KEY" | base64 --decode 2>/dev/null)

# Check if decoding was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to decode HEROKU_API_KEY."
    exit 1
fi

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
if ! heroku logs --app "$HEROKU_APP_NAME" > heroku_logs.txt 2>&1; then
    echo "Error: Failed to fetch logs from Heroku. Check heroku_logs.txt for details."
    exit 1
else
    echo "Logs fetched successfully. Check heroku_logs.txt for details."
fi