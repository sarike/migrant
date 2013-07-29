# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    BaseHandler for reqest
"""
from kpages import ContextHandler,url
from logic.utility import m_update,m_del,m_page,m_info
from logic import city

class RestfulHandler(ContextHandler):
    uid = property(lambda self:self.get_secure_cookie('uid'))

    def prepare(self):
        if not self.uid:
            self.write(dict(status = False,errormsg = 'not login'))
            self.finish()

@url(r'/m/city/info')
class InfoHandler(ContextHandler):
    def get(self):
        r,v= m_info(city.TName,self.get_argument('id'))
        self.write(dict(status = r, data = v))


@url(r'/m/(.*)/del')
class DelHandler(RestfulHandler):
    def get(self,table):
        r,v= m_del(table,self.get_argument('id'))
        self.write(dict(status = r, data = v))

@url(r'/m/(.*)/page')
class PageHandler(RestfulHandler):
    def get(self,table):
        r,v= m_page(table,since = self.get_argument('since',None),addon=self.get_argument('addon',None))
        if r:
            self.write(dict(status = r, data = v,uid = self.uid))
        else:
            self.write(dict(status = r, data =v))


@url(r'/m/city/list')
@url(r'/m/city/list/(.*)')
class CityHandler(ContextHandler):
    def get(self,parent = None):
        if not parent:parent = None
        lst = city.getList(parent)
        self.write(dict(status=True,data = lst))
