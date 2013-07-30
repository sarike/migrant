# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    资讯报告管理逻辑
"""
from kpages import not_empty,get_context,mongo_conv
from utility import m_update,m_del,m_page,m_exists

TName = 'report'
Tb = lambda :get_context().get_mongo()[TName]

def add(title, pid, body, **kwargs):
    ''' add report '''
    try:
        not_empty(title,body)
        val = dict(title = title, pid = pid, body = body)
        val.update(kwargs)
        _id = Tb().insert(val, saft = True)
        val["_id"] = str(_id)

    except Exception as e:
        return False, e.message

    return True, val


