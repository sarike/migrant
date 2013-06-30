# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    BaseHandler for reqest
"""
from kpages import ContextHandler

class RestfulHandler(ContextHandler):
    
    uid = lambda:self.get_argument('uid')
