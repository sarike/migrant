# -*- coding:utf-8 -*- 
"""
    account action 
    author comger@gmail.com
"""
import base64
import json
from exceptions import ValueError
from kpages import url
from utility import RestfulHandler

from logic.utility import *
from logic.post import add

@url(r'/m/post/create')
class CreaterHandler(RestfulHandler):
    def get(self):
        try:
            body = self.get_argument('body',None)
            city = self.get_argument('city',None)
            lg = float(self.get_argument('lg',0.0))
            lt = float(self.get_argument('lt',0.0))
            args = {}
            if lg and lt:
                args.update(lg=lg,lt=lt)
            
            r,v = add(self.uid,body,city,**args)
            self.write(dict(status=r,data = v))
        except ValueError as e:
            self.write(dict(status=False,data='输入参数格式错误',errormsg = e.message))
        except Exception as e:
            self.write(dict(status=False,data='程序异常',errormsg = e.message))


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


