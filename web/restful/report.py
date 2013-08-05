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
from logic.report import add,TName as T_REPORT,citys_list
from logic.account import TName as T_ACCOUNT,conv_user


@url(r'/m/report/home')
class HomeHandler(RestfulHandler):
    def get(self):
        try:
            ur,uv = m_info(T_ACCOUNT,self.uid)
            citys = (uv['city'],uv['tocity'])
            r,v = citys_list(self.get_argument('since',None),uv['city'],uv['tocity'])
            self.write(dict(status=r,data = v))
        except KeyError as e:
            self.write(dict(status=False,data='用户未设置相关城市',errormsg=e.message))
        except TypeError as e:
            self.write(dict(status=False,data='没有该用户',errormsg=e.message))


@url(r'/m/report/city')
@url(r'/m/report/city/(.*)')
class CityHandler(ContextHandler):
    def get(self,_id=None):
        r,v = m_page(T_REPORT,self.get_argument('since',None),city=_id)
        self.write(dict(status=r,data = v))
        

