# -*- coding:utf-8 -*- 
"""
    index action
    author comger@gmail.com
"""
from tornado.web import RequestHandler
from kpages import url,ContextHandler

@url(r"/")
class IndexHandler(ContextHandler,RequestHandler):
    def get(self):
        self.render('index.html')
