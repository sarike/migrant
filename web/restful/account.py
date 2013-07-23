# -*- coding:utf-8 -*- 
"""
    account action 
    author comger@gmail.com
"""
import json
from kpages import url,ContextHandler
from utility import RestfulHandler

from logic.utility import *
from logic.account import add,login,TName as T_ACCOUNT,auth_login
from logic.city import TName as T_CITY

@url(r'/m/account/login')
class LoginHandler(ContextHandler):
    def post(self):
        print self.request
        r,v = login(self.get_argument('username'),self.get_argument('password'))
        if r:
            self.set_secure_cookie('uid',v['_id'])
            del v['password']
            del v['status']

        self.write(dict(status = r, data = v))

    def get(self):
        r,v = login(self.get_argument('username'),self.get_argument('password'))
        if r:
            self.set_secure_cookie('uid',v['_id'])
            del v['password']
            del v['status']

        self.write(dict(status = r, data = v))


@url(r'/m/auth/login')
class AuthLoginHandler(ContextHandler):
    def post(self):
        r,v = auth_login(self.get_argument('site'),self.get_argument('otherid'),self.get_argument('name'))
        if r:
            self.set_secure_cookie('uid',v['_id'])
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
        tocity = self.get_argument('tocity',None)
        if tocity:val.update(tocity=tocity)

        city = self.get_argument('city',None)
        if city:val.update(city=city)
        
        icon = self.get_argument('icon',None)
        if icon:val.update(icon=icon)

        r,v = m_update(T_ACCOUNT,self.uid,**val)
        self.write(dict(status = r, data = v))


@url(r'/m/account/info')
@url(r'/m/account/info/(.*)')
class InfoHandler(RestfulHandler):
    def get(self,_id = None):
        r,v = m_info(T_ACCOUNT,_id or self.uid)
        if not r:
            return self.write(dict(status=r,data =v))

        if v and v.get('city',None):
            cr,cv = m_info(T_CITY,v['city'])
            v['cityname'] = cv['name']

        if v and v.get('tocity',None):
            cr,cv = m_info(T_CITY,v['tocity'])
            v['tocityname'] = cv['name']

        self.write(dict(status=True,data=v))
