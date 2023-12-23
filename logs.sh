
It seems that the script is not able to find the HEROKU_API_KEY environment variable, even though it's present in the environment variables list you provided. One reason this could happen is if the variable is set after the script starts running.

To address this, you can try modifying your script to print out all environment variables at the beginning, before checking for the existence of HEROKU_API_KEY. This will help verify whether the variable is indeed set.

Here's a modified version of your script:

bash
Copy code
#!/bin/bash

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

# Set Heroku API key for authentication
HEROKU_API_KEY_DECODED=$(echo "$HEROKU_API_KEY" | base64 --decode)

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
if ! heroku logs --app "$HEROKU_APP_NAME"; then
    echo "Error: Failed to fetch logs from Heroku."
    exit 1
fi