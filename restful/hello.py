# -*- coding:utf-8 -*- 
from tornado.web import RequestHandler
from tornado.router import url

from kpages import LogicContext, get_context

@url(r'/hello')
class HelloHandler(RequestHandler):
    def get(self):
        with LogicContext():
            db = get_context().get_mongo()
            print db['account']
        self.write('hello migrant')

@url(r'/json')
class JsonHandler(RequestHandler):
    def get(self):
        self.write(dict(status = True, data = 'json test'))
