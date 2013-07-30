#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    分类管理逻辑
"""

from kpages import not_empty,get_context,mongo_conv
from utility import m_update,m_del,m_page,m_exists

TName = 'category'
Tb = lambda :get_context().get_mongo()[TName]

def add(name, groupid, listname, intro, **kwargs):
    ''' add category '''
    not_empty(name, listname,groupid)
    val = dict(name = name, groupid = groupid, listname = listname,intro = intro)
    val.update(kwargs)
    try:
        _id = Tb().insert(val, saft = True)
        val["_id"] = str(_id)

    except Exception as e:
        return False, e.message

    return True, val


def info_category_listname(listname):
    ''' category info by listname '''
    not_empty(listname)
    try:
        val = Tb().find_one(dict(listname = listname))
        val["_id"] = str(val['_id'])
        return val
    
    except Exception as e:
        return None
    
