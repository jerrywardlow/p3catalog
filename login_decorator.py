from functools import wraps
from flask import request, redirect, url_for
from flask import session as login_session

def login_required(f):
    @wraps(f)
    def x(*args, **kwargs):
        if 'username' not in login_session:
            return redirect('/login')
        return f(*args, **kwargs)
    return x
