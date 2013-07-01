# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    BaseHandler for reqest
"""
from kpages import ContextHandler,url
from logic.utility import m_update,m_del,m_page

class RestfulHandler(ContextHandler):
    
    uid = lambda:self.get_argument('uid')

@url('/m/(.*)/del/(.*)')
class DelHandler(ContextHandler):
    def get(self,table,_id=None):
        m_del(table,_id)


