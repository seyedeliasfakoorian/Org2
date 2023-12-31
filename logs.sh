#!/bin/bash

# Function to check if a required environment variable is set
check_env_variable() {
    if [ -z "${!1}" ]; then
        echo "Error: $1 environment variable must be set."
        exit 1
    fi
}

# Set Heroku API URLs
HEROKU_LOGS_API_URL="https://api.heroku.com/apps/website-breaker-demo/logs"
HEROKU_RELEASES_API_URL="https://api.heroku.com/apps/website-breaker-demo/releases"

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
    
    # Additional steps to create a pull request on GitHub for fixing log fetching failure
    echo "Creating a pull request for Heroku log fetching failure..."
    
    # Assuming 'gh' command-line tool is installed and configured
    gh pr create --base main --head fix-heroku-log-fetching --title "Fix Heroku log fetching failure" --body "This pull request can fix log fetching issues when Heroku has an issue deploying or needs to check logs🚀
    🌎 [Heroku App](https://website-breaker-demo-2e92fbab7def.herokuapp.com/)" \
    --base main --branch github-actions --commit-message "Fix Heroku Vulnerabilities" --delete-branch true --labels "github actions" --reviewers seyedeliasfakoorian
fi

# Make a request to Heroku API to get release status
HEROKU_STATUS=$(curl -n -s "$HEROKU_RELEASES_API_URL" \
  -H "Accept: application/vnd.heroku+json; version=3" \
  -H "Authorization: Bearer $HEROKU_API_KEY_DECODED" \
  | jq -r 'if type == "array" then .[0].status else "succeeded" end')

# Print Heroku status
echo "Heroku Deployment Status: $HEROKU_STATUS"

# Check if deployment failed
if [ "$HEROKU_STATUS" != "succeeded" ]; then
  # Additional steps to create a pull request on GitHub for fixing Heroku deployment failure
  echo "Creating a pull request for Heroku deployment failure..."
  
  # Assuming 'gh' command-line tool is installed and configured
  gh pr create --base main --head fix-heroku-deployment --title "Fix Heroku deployment failure" --body "This pull request can fix deployment issues when Heroku has an issue deploying or needs to check logs🚀
  🌎 [Heroku App](https://website-breaker-demo-2e92fbab7def.herokuapp.com/)" \
  --base main --branch github-actions --commit-message "Fix Heroku Vulnerabilities" --delete-branch true --labels "github actions" --reviewers seyedeliasfakoorian
fi

# If both log fetching and deployment fail, create a combined pull request
if [ "$HEROKU_STATUS" != "succeeded" ] && ! heroku logs --app website-breaker-demo; then
    echo "Creating a pull request for both issues..."
    
    # Assuming 'gh' command-line tool is installed and configured
    gh pr create --base main --head fix-both-issues --title "Fix Heroku Log Fetching and Deployment Failures" --body "This pull request can fix both log fetching and deployment issues when Heroku has an issue deploying or needs to check logs🚀
    🌎 [Heroku App](https://website-breaker-demo-2e92fbab7def.herokuapp.com/)" \
    --base main --branch github-actions --commit-message "Fix Heroku Vulnerabilities" --delete-branch true --labels "github actions" --reviewers seyedeliasfakoorian
fi
