#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    分组管理逻辑
    1. 分组 group { 
        'name':'分组名称',
        'listname':'域名',
        'keykword':'关键词',
        'remark':'描述',
        'title':'标题'
    }
"""

from kpages import not_empty,get_context,mongo_conv
from utility import m_update,m_del,m_page,m_exists

TName = 'groupinfo'
Tb = lambda :get_context().get_mongo()[TName]

def add(name, listname, **kwargs):
    ''' add group '''
    not_empty(name, listname)
    r = m_exists(TName,name=name,listname=listname)
    if r:
        return False,'存在name 或 listname '

    val = dict(name = name, listname = listname)
    val.update(kwargs)
    try:
        _id = Tb().insert(val, saft = True)
        val["_id"] = str(_id)

    except Exception as e:
        return False, e.message

    return True, val


def info_group_listname(listname):
    not_empty(listname)
    try:
        val = Tb()().find_one(dict(listname = listname))
        val['_id'] = str(val['_id'])
        return val
    
    except Exception as e:
        return None

    return None
    
    
