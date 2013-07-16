# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    BaseHandler for reqest
"""
from kpages import ContextHandler,url
from logic.utility import m_update,m_del,m_page

class RestfulHandler(ContextHandler):
    uid = property(lambda self:self.get_secure_cookie('uid'))

    def prepare(self):
        if not self.uid:
            self.write(dict(status = False,errormsg = 'not login'))
            self.finish()


@url(r'/m/(.*)/del')
class DelHandler(RestfulHandler):
    def get(self,table):
        r,v= m_del(table,self.get_argument('id'))
        self.write(dict(status = r, data = v))


@url(r'/m/(.*)/page')
class PageHandler(RestfulHandler):
    def get(self,table):
        print self.uid
        r,v= m_page(table,since = self.get_argument('since',None),addon=self.get_argument('addon',None))
        if r:
            if table == 'account':
                for item in v:del item['password']
            self.write(dict(status = r, data = v,uid = self.uid))
        else:
            self.write(dict(status = r, data =v))
