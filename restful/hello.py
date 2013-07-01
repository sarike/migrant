# -*- coding:utf-8 -*- 
from kpages import url
from utility import RestfulHandler


@url(r'/hello')
class HelloHandler(RestfulHandler):
    def get(self):
        self.write(dict(status = True, data = 'hello'))


@url(r'/json')
class JsonHandler(RestfulHandler):
    def get(self):
        self.write(dict(status = True, data = 'json'))
