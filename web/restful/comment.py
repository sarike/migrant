# -*- coding:utf-8 -*- 

"""
    comment action 
    author comger@gmail.com
"""
import json
from kpages import url,ContextHandler
from utility import RestfulHandler

from logic.comment import add,list_by_user,list_by_post

@url(r'/m/comment/create')
class CreateHandler(RestfulHandler):
    def get(self):
        r,v = add(self.uid,self.get_argument('pid',None),self.get_argument('body'))
        self.write(dict(status=r,data=v))


@url(r'/m/comment/userlist')
@url(r'/m/comment/userlist/(.*)')
class UserListHandler(RestfulHandler):
    def get(self,_id = None):
        r,v = list_by_user(_id or self.uid,self.get_argument('since',None))
        self.write(dict(status=r,data=v))
        

@url(r'/m/comment/postlist/(.*)')
class PostListHandler(RestfulHandler):
    def get(self,_id = None):
        r,v = list_by_post(_id,self.get_argument('since',None))
        self.write(dict(status=r,data=v))
