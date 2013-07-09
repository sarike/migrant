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

@url(r'/m/post/create')
class CreaterHandler(RestfulHandler):
    def get(self):
        uid = self.uid
        body = self.get_argument('body',None)
        city = self.get_argument('city',None)
        lg = float(self.get_argument('lg',0.0))
        lt = float(self.get_argument('lt',0.0))
        self.write(dict(status=True,data = {}))


@url(r'/m/post/home')
class HomeHandler(RestfulHandler):
    def get(self):
        uid = self.uid
        self.write(dict(status=True,data = ()))


@url(r'/m/post/my')
class MyHandler(RestfulHandler):
    def get(self):
        uid = self.uid
        self.write(dict(status=True,data = ()))


@url(r'/m/post/person')
class PersonHandler(RestfulHandler):
    def get(self):
        uid = self.uid
        self.write(dict(status=True,data = ()))


