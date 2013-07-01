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
from logic.account import add,login,TName as T_ACCOUNT

@url(r'/m/account/login')
class LoginHandler(RestfulHandler):
    def get(self):
        r,v = login(self.get_argument('username'),self.get_argument('password'))
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
        r,v = m_update(T_ACCOUNT,self.uid,city=self.get_argument('city',None), tel=self.get_argument('tel',None))
        self.write(dict(status = r, data = v))


