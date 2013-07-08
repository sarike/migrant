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
