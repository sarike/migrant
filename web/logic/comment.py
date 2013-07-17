# -*- coding:utf-8 -*- 
"""
    主题讨论逻辑
    author comger@gmail.com
"""
from kpages import not_empty,get_context,mongo_conv
from utility import m_update,m_del,m_page,m_exists,m_info

from account import TName as T_ACCOUNT
from post import TName as T_POST

TName = 'comment'
Tb = lambda :get_context().get_mongo()[TName]

def add(uid,pid,bodyi,**kwargs):
    not_empty(uid,pid,body)
    try:
        val = dict(uid=uid,pid=pid,body=body)
        _id = Tb().insert(val,saft=True)
        val['_id'] = str(_id)
        return True,val
    except Exception as e:
        return False,e.message


def list_by_user(uid,since=None,size=10):
    not_empty(uid)
    cond = dict(uid=uid)
    r,lst = m_page(TName,since,size,**cond)
    arr = []
    for item in lst:
        try:
            item['user'] = m_info(T_ACCOUNT,item['uid'])['username']
            item['title'] = m_info(T_POST,item['pid'])['body']
            arr.append(item)
        except Exception as e:
            pass

    return r,arr


def list_by_post(pid,since=None,size=10):
    not_empty(pid)
    cond = dict(pid=pid)
    r,lst = m_page(TName,since,size,**cond)
    arr = []
    for item in lst:
        try:
            item['user'] = m_info(T_ACCOUNT,item['uid'])['username']
            arr.append(item)
        except Exception as e:
            pass

    return r,arr
