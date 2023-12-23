#!/bin/bash

# Check if required environment variables are set
if [ -z "$HEROKU_APP_NAME" ] || [ -z "$HEROKU_API_KEY" ]; then
    echo "Error: HEROKU_APP_NAME and HEROKU_API_KEY environment variables must be set."
    exit 1
fi

# Set Heroku API key for authentication
HEROKU_API_KEY=$(echo "$HEROKU_API_KEY" | base64 --decode)

# Extract email and password from API key
HEROKU_EMAIL=$(echo "$HEROKU_API_KEY" | cut -d: -f1)
HEROKU_PASSWORD=$(echo "$HEROKU_API_KEY" | cut -d: -f2)

# Log in using Heroku API key
echo "Logging in to Heroku..."
echo -e "${HEROKU_EMAIL}\n${HEROKU_PASSWORD}" | heroku login --interactive

# Check if the login was successful
if [ $? -ne 0 ]; then
    echo "Error: Heroku login failed."
    exit 1
else
    echo "Heroku login successful."
fi

# Fetch logs using Heroku API
echo "Fetching logs from Heroku..."
heroku logs --app "$HEROKU_APP_NAME"