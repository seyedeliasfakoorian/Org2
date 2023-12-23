# Heroku App Name
HEROKU_APP_NAME='website-breaker-demo'

# Set Heroku API key for authentication
HEROKU_API_KEY=$(cat secrets.HEROKU_API_KEY)
echo $HEROKU_API_KEY | heroku login --interactive

# Fetch logs using Heroku API
heroku logs --app website-breaker-demo