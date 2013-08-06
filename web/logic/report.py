# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    资讯报告管理逻辑
"""
from kpages import not_empty,get_context,mongo_conv
from utility import m_update,m_del,m_page,m_exists

TName = 'report'
Tb = lambda :get_context().get_mongo()[TName]

def add(title, pid,city, body,source=None, **kwargs):
    ''' add report '''
    try:
        not_empty(title,body)
        val = dict(title = title, pid = pid,city=city, body = body,source=source)
        r = m_exists(TName,title=title,pid=pid)
        if not r:
            val.update(kwargs)
            _id = Tb().insert(val, saft = True)
            val["_id"] = str(_id)
        else:
            return False,'exists'

    except Exception as e:
        return False, e.message

    return True, val


def citys_list(since,*citys,**kwargs):
    cond = {'city':{'$in':citys}}
    return m_page(TName,since,10,**cond)
