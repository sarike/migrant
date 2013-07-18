# -*- coding:utf-8 -*- 
"""
    index action
    author comger@gmail.com
"""
from kpages import url,ContextHandler

@url(r"/")
class IndexHandler(ContextHandler):
    def get(self):
        self.render('index.html')
