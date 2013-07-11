# -*- coding:utf-8 -*- 
"""
    account action 
    author comger@gmail.com
"""
import base64
import json
from kpages import url
from utility import RestfulHandler

from logic.utility import *
from logic.account import add,login,TName as T_ACCOUNT,auth_login

@url(r'/m/account/login')
class LoginHandler(RestfulHandler):
    def post(self):
        r,v = login(self.get_argument('username'),self.get_argument('password'))
        if r:
            token = dict(uid = v['_id'],host = self.request.host)
            v['token'] = base64.b64encode(json.dumps(token))
            self.set_secure_cookie('uid',v['_id'])
            del v['password']
            del v['status']

        self.write(dict(status = r, data = v))


@url(r'/m/auth/login')
class AuthLoginHandler(RestfulHandler):
    def get(self):
        r,v = auth_login(self.get_argument('site'),self.get_argument('otherid'),self.get_argument('name'))
        if r:
            token = dict(uid = v['_id'],host = self.request.host)
            v['token'] = base64.b64encode(json.dumps(token))
            del v['password']
            del v['status']

        self.write(dict(status = r, data = v))


@url(r'/m/account/add')
class AddHandler(RestfulHandler):
    def get(self):
        r,v = add(self.get_argument('username'),self.get_argument('password'),self.get_argument('city',None))
        self.write(dict(status = r, data = v))


@url(r'/m/account/update')
class UpdateHandler(RestfulHandler):
    def get(self):
        val = dict()
        tocity = self.get_arguments('tocity',None)
        if tocity:
            val.update(tocity=tocity)

        city = self.get_arguments('city',None)
        if city:
            val.update(city=city)

        r,v = m_update(T_ACCOUNT,self.uid,**val)
        self.write(dict(status = r, data = v))


