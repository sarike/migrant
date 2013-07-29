# -*- coding:utf-8 -*- 
"""
    用户名片
    author comger@gmail.com
"""
from kpages import not_empty,get_context,mongo_conv
from utility import m_update,m_del,m_page,m_exists

TName = 'usercard'
Tb = lambda :get_context().get_mongo()[TName]

def add(uid,job,tel):
    pass
