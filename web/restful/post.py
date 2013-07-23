# -*- coding:utf-8 -*- 
"""
    account action 
    author comger@gmail.com
"""
import base64
import json
from exceptions import ValueError,KeyError
from kpages import url,ContextHandler
from utility import RestfulHandler

from logic.utility import *
from logic.post import add,TName as T_POST,home
from logic.account import TName as T_ACCOUNT


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
        try:
            ur,uv = m_info(T_ACCOUNT,self.uid)
            citys = (uv['city'],uv['tocity'])
            r,v = home(self.uid,citys,self.get_argument('since',None))
            self.write(dict(status=r,data = v))
        except KeyError as e:
            self.write(dict(statis=False,data='用户未设置相关城市',errormsg=e.message))
        except TypeError as e:
            self.write(dict(statis=False,data='没有该用户',errormsg=e.message))



@url(r'/m/post/my')
@url(r'/m/post/my/(.*)')
class MyHandler(RestfulHandler):
    def get(self,_id=None):
        r,v = m_page(T_POST,self.get_argument('since',None),uid=_id or self.uid)
        self.write(dict(status=r,data = v))



@url(r'/m/post/city')
@url(r'/m/post/city/(.*)')
class CityHandler(ContextHandler):
    def get(self,_id=None):
        r,v = m_page(T_POST,self.get_argument('since',None),city=_id)
        self.write(dict(status=r,data = v))
        

