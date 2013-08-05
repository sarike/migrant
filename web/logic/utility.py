# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
"""
from bson.objectid import ObjectId
from bson.errors import InvalidId
from kpages import get_context,mongo_conv,not_empty 

Tb = lambda table:get_context().get_mongo()[table]

#查询非删除状态的数据
StatusCond = {'status':{'$ne':-1}}

def m_update(table,_id,**kwargs):
    try:
        not_empty(table,_id)
        cond = dict(_id = ObjectId(_id))
        cond.update(StatusCond)
        Tb(table).update(cond,{'$set':kwargs})
        return True,None
    except InvalidId as e:
        return False,"查询参数格式错误"
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
            cond = dict(_id = ObjectId(_id))
            cond.update(StatusCond)
            Tb(table).update(cond,{'$set':{'status':-1}})
    except InvalidId as e:
        return False,"查询参数格式错误"
    except Exception as e:
        return False, e.message

    return True,None

def m_page(table,since=None,size=10,**kwargs):
    """
        通用数据集查询方案,一次性获取size条大于since 及大于addon的数据记录
    """
    try:
        cond = {}
        cond.update(StatusCond)
        cond_id = None
        if since:
            cond_id = ObjectId(since)
            cond.update(_id = {'$gt':cond_id})
        cond.update(kwargs)
        
        if cond.get('addon',None):
            #查询addon 时间以后的记录 
            t = float(cond.pop('addon'))
            t = hex(int(t))[2:]
            _id = '{0}{1}'.format(t,'0'*16)
            if cond_id and cond_id <ObjectId(_id):
                cond.update({'_id':{'$gt':ObjectId(_id)}})
        elif 'addon' in cond:
            cond.pop('addon')
        
        print cond,StatusCond
        lst = list(Tb(table).find(cond,{'status':0,'password':0}).limit(size).sort('_id',-1))
        for item in lst:
            if 'addon' not in item:item['addon'] = item['_id'].generation_time.strftime('%Y:%m:%d %H:%M:%S')
        
        return True, mongo_conv(lst)
    except Exception as e:
        return False,e.message

def m_exists(table,**cond):
    cond.update(StatusCond)
    return Tb(table).find_one(cond)

def m_info(table,_id):
    not_empty(_id)
    try:
        cond = dict(_id=ObjectId(_id))
        cond.update(StatusCond)
        return True,mongo_conv(Tb(table).find_one(cond,{'status':0,'password':0}))
    except InvalidId as e:
        return False,"查询参数格式错误"
    except Exception as e:
        return False,e.message
