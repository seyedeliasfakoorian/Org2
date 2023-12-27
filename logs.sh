#!/usr/bin/env bash

# Function to check if a required environment variable is set
check_env_variable() {
    if [ -z "${!1}" ]; then
        echo "Error: $1 environment variable must be set."
        exit 1
    fi
}

# Check if the 'heroku' command is available
if ! command -v heroku &> /dev/null; then
    echo "Error: 'heroku' command not found. Please make sure it's installed."
    exit 1
fi

# Check if required environment variables are set
check_env_variable "secrets.HEROKU_APP_NAME"
check_env_variable "secrets.HEROKU_API_KEY"

# Decode Heroku API key for authentication
HEROKU_API_KEY_DECODED=$(echo "${secrets.HEROKU_API_KEY}" | base64 --decode)

# Login to Heroku with .netrc
echo -e "machine api.heroku.com\n  login $HEROKU_API_KEY_DECODED" > ~/.netrc
chmod 600 ~/.netrc

# Fetch logs using Heroku API
echo "Fetching logs from Heroku for app: website-breaker-demo..."
if ! heroku logs --app website-breaker-demo; then
    echo "Error: Failed to fetch logs from Heroku for app: website-breaker-demo"
    exit 1
fi
