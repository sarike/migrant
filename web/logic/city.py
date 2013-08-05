# -*- coding:utf-8 -*- 
"""
    city logic (curd)
    author comger@gmail.com
"""
from kpages import not_empty,get_context,mongo_conv
from utility import m_update,m_del,m_page,m_exists,StatusCond

TName = 'city'
Tb = lambda :get_context().get_mongo()[TName]

CITY_VAL = {}
CITY_NAME = {}
citys = Tb().find({'level':{'$in':[0,1]}})
for _city in citys:
    CITY_VAL[_city['name']]=str(_city['_id'])
    CITY_NAME[str(_city['_id'])] = _city['name']

def add(name,parent=None,level=0):
    try:
        not_empty(name)
        r = m_exists(TName,name=name,parent=parent,level=level)
        if not r:
            val = dict(name=name,parent=parent,level=level)
            _id = Tb().insert(val,saft=True)
            val['_id'] = str(_id)
            return True,val
        else:
            return False,'EXITS'
    except Exception as e:
        return False,e.message

def getList(parent=None):
    cond = dict(parent=parent)
    cond.update(StatusCond)
    lst = list(Tb().find(cond,{'id':0,'status':0}))
    return mongo_conv(lst)

