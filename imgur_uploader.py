from flask import request
from base64 import b64encode
import pyimgur

from website_config import IMGUR_CLIENT_ID

def imgur_upload(target_file):
    '''Reads and encodes the target file before uploading to Imgur'''
    data = b64encode(target_file.read())
    client = pyimgur.Imgur(IMGUR_CLIENT_ID)
    image = client._send_request('https://api.imgur.com/3/image',
                             method='POST',
                             params={'image': data})
    try:
        return image['link']
    except:
        return None

def imgur_small_square(link):
    return link[:-4] + 's' + link[-4:]

def imgur_medium_thumb(link):
    return link[:-4] + 'm' + link[-4:]
