# -*- coding:utf-8 -*- 
"""
    post logic (curd)
    author comger@gmail.com
"""
from kpages import not_empty,get_context,mongo_conv
from utility import m_update,m_del,m_page,m_exists,StatusCond

TName = 'post'
Tb = lambda :get_context().get_mongo()[TName]

def add(uid,body,city=None,**kwargs):
    try:
        not_empty(uid,body)
        r = m_exists(TName,uid=uid,body=body)
        if not r:
            val = dict(uid=uid,body=body,city=city)
            val.update(kwargs)
            _id = Tb().insert(val,saft=True)
            val['_id'] = str(_id)
            return True,val
        else:
            return False,'EXITS'
    except Exception as e:
        return False,e.message


def home(uid,citys,since=0,size=10):
    cond = {'$or':[{'uid':uid},{'city':{'$in':citys}}]}
    return m_page(TName,since,size,**cond)

