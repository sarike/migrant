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
        if not all((self.token,self.uid)):
            self.write(dict(status = False,errormsg = 'not uid or token '))
            self.finish()

@url('/m/(.*)/del/(.*)')
class DelHandler(ContextHandler):
    def get(self,table,_id=None):
        m_del(table,_id)


