import json

SECRET_KEY = 'super_super_secret_secret_key'
DEBUG = True
CLIENT_SECRETS = 'client_secrets.json'
CLIENT_ID = json.loads(open(CLIENT_SECRETS, 'r').read())['web']['client_id']

IMGUR_CLIENT_ID = 'PLACE IMGUR CLIENT ID HERE'
