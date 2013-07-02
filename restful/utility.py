# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    BaseHandler for reqest
"""
from kpages import ContextHandler,url
from logic.utility import m_update,m_del,m_page

class RestfulHandler(ContextHandler):
    token = property(lambda self:self.get_argument('token',None)) 
    uid = property(lambda self:self.get_argument('uid',None))

    def prepare(self):
        '''
        if not all((self.token,self.uid)):
            self.write(dict(status = False,errormsg = 'not uid or token '))
            self.finish()
        '''
        pass


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
            if table == 'account':
                for item in v:del item['password']
            self.write(dict(status = r, data = v))
        else:
            self.write(dict(status = r, data =v))
