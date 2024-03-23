#!/bin/bash

# Function to check if a required environment variable is set
check_env_variable() {
    if [ -z "${!1}" ]; then
        echo "Error: $1 environment variable must be set."
        exit 1
    fi
}

# Check if required environment variables are set
check_env_variable "HEROKU_APP_NAME"
check_env_variable "GITHUB_TOKEN"

# Fetch Heroku API key using GitHub Actions API
HEROKU_API_KEY=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_REPOSITORY/deployments" | \
    jq -r '.[0].environment_variables[] | select(.name == "HEROKU_API_KEY").value')

# Set Heroku API URLs
HEROKU_LOGS_API_URL="https://api.heroku.com/apps/$HEROKU_APP_NAME/logs"
HEROKU_RELEASES_API_URL="https://api.heroku.com/apps/$HEROKU_APP_NAME/releases"

# Check if the 'heroku' command is available
if ! command -v heroku &> /dev/null; then
    echo "Error: 'heroku' command not found. Please make sure it's installed."
    exit 1
fi

# Decode Heroku API key for authentication
HEROKU_API_KEY_DECODED=$(echo "$HEROKU_API_KEY" | base64 --decode)

# Fetch logs using Heroku API
echo "Fetching logs from Heroku for app: $HEROKU_APP_NAME..."
if ! HEROKU_API_KEY="$HEROKU_API_KEY_DECODED" heroku logs --app "$HEROKU_APP_NAME" 2>&1 >/dev/null; then
    echo "Error: Failed to fetch logs from Heroku for app: $HEROKU_APP_NAME"
    exit 1
fi

# Make a request to Heroku API to get release status
HEROKU_DEPLOYMENT_STATUS=$(curl -n -s "$HEROKU_RELEASES_API_URL" \
  -H "Accept: application/vnd.heroku+json; version=3" \
  -H "Authorization: Bearer $HEROKU_API_KEY_DECODED" \
  | jq -r 'if type == "array" then .[0].status else "succeeded" end')

# Print Heroku Deployment status
echo "Heroku Deployment Status: $HEROKU_DEPLOYMENT_STATUS"

# Check if deployment failed
if [ "$HEROKU_DEPLOYMENT_STATUS" != "succeeded" ]; then
  echo "Heroku deployment failed."
fi
