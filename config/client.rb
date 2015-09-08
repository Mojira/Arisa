# The server hosting the bug tracker
SITE = 'https://bugs.mojang.com'

# The base path to use in requests to the server
CONTEXT_PATH = ''

# Read the bot's credentials from the environment.
# You can change this behaviour, but it's not recommended to do so.

# WARNING:
# DO NOT ENTER THE PASSWORD DIRECTLY INTO A FILE
# THIS REPOSITORY IS PUBLIC

USERNAME = ENV['ARISA_AUTH_USERNAME']
PASSWORD = ENV['ARISA_AUTH_PASSWORD']

# Option hash for the JIRA API client
CLIENT_OPTIONS = {
    auth_type:   :basic,
    username:	 USERNAME,
    password:	 PASSWORD,
    site:		 SITE,
    context_path:CONTEXT_PATH
}
