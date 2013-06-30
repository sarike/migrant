# -*- coding:utf-8 -*- 
from tornado.web import RequestHandler

from kpages import LogicContext, get_context,url,mongo_conv
from utility import RestfulHandler

from logic import account,category

@url(r'/hello')
class HelloHandler(RestfulHandler):
    def get(self):
        rs = account.page()
        self.write(dict(status = True,data =rs))

@url(r'/json')
class JsonHandler(RequestHandler):
    def get(self):
        self.write(dict(status = True, data = category.page()))
