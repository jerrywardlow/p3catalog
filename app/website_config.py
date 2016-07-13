import json

IMGUR_CLIENT_ID = 'PLACE IMGUR CLIENT ID HERE'

SECRET_KEY = 'super_super_secret_secret_key'
DEBUG = False
CLIENT_SECRETS = 'client_secrets.json'
try:
    CLIENT_ID = json.loads(open(CLIENT_SECRETS, 'r').read())['web']['client_id']
except:
    CLIENT_ID = False
