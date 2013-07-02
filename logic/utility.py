# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
"""
from bson.objectid import ObjectId
from kpages import get_context,mongo_conv,not_empty 

Tb = lambda table:get_context().get_mongo()[table]

def m_update(table,_id,**kwargs):
    try:
        not_empty(table,_id)
        Tb(table).update(dict(_id = ObjectId(_id),status = 0),{'$set':kwargs})
        return True,None
    except Exception as e:
        return False,e.message


def m_del(table,_id,is_del=False):
    '''
        通用删除逻辑
        table : 表名
        _id : 主键
        is_del: 是否为硬删除
    '''
    try:
        not_empty(table,_id)
        if is_del:
            Tb(table).remove(dict(_id = ObjectId(_id)))
        else:
            Tb(table).update(dict(_id = ObjectId(_id),status = 0),{'$set':{'status':1}})
    except Exception as e:
        return False, e.message

    return True,None

def m_page(table,since=None,size=10,**kwargs):
    cond = dict(status = 0)
    if since:
        cond.update(_id = {'$gt':ObjectId(since)})
    cond.update(kwargs)

    if cond.get('addon',None):
        t = float(cond.pop('addon'))
        t = hex(int(t/1000))
        _id = '{0}{1}'.format(t,'0'*16)
        cond.update({'_id':{'$gt':ObjectId(_id)}})
    
    print cond
    lst = list(Tb(table).find(cond).limit(size))
    for item in lst:
        pass

    return mongo_conv(lst)

def m_exists(table,**cond):
    cond.update(status = 0)
    return Tb(table).find_one(cond)


