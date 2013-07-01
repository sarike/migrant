# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
"""
from kpages import get_context,mongo_conv 

class BaseLogic(object):
    name = None

    @staticmethod
    def get_db(cls):
        return get_context().get_mongo()[name]

    @staticmethod
    def page(cls,index=0,size=10,**cond):
        cond.update(status=0)
        lst = list(tb().find(cond).skip(index*size).limit(size))
        return mongo_conv(lst)


get_tb = lambda name:get_context().get_mongo()[name]

def m_update(table,_id,**kwargs):
    try:
        get_tb(table).update(dict(_id = ObjectId_id,status = 0),kwargs)
    except Exception as e:
        return False,e.message

    return True,None

def m_del(table,_id,is_del=False):
    '''
        通用删除逻辑
        table : 表名
        _id : 主键
        is_del: 是否为硬删除
    '''
    try:
        if is_del:
            get_tb(table).remove(dict(_id = ObjectId(_id)))
        else:
            get_tb(table).update(dict(_id = ObjectId_id,status = 0),{'$set':{'status':1}})
    except Exception as e:
        return False, e.message

    return True,None

def m_page(table,since=None,size=10,**kwargs):
    cond = dict(status = 0)
    if since:
        cond.update(_id = {'$ln':ObjectId(since)})
    cond.update(kwargs)
    lst = list(get_tb(table).find(cond).limit(size))
    return mongo_conv(lst)
