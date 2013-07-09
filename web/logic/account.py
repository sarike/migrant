# -*- coding:utf-8 -*- 
"""
    account logic (curd)
    author comger@gmail.com
"""
from kpages import not_empty,get_context,mongo_conv
from utility import m_update,m_del,m_page,m_exists

TName = 'account'
Tb = lambda :get_context().get_mongo()[TName]

def add(username,password,city):
    try:
        not_empty(username,password)
        r = m_exists(TName,username=username,password=password)
        if not r:
            val = dict(username=username,password=password,city=city,status=0)
            _id = Tb().insert(val,saft=True)
            val['_id'] = str(_id)
            return True,val
        else:
            return False,'EXITS'
    except Exception as e:
        return False,e.message

def login(username,password):
    try:
        not_empty(username,password)
        r = m_exists(TName,username=username,password=password)
        if r:
            r = mongo_conv(r)
            return True, r
        else:
            return False,None
    except Exception as e:
        return False,e.message


def auth_login(site,otherid,name,**kwargs):
    try:
        not_empty(site,otherid,name)
        r = m_exists(TName,site=site,otherid=otherid,name=name)
        if r:
            r = mongo_conv(r)
            return True,r
        else:
            val = dict(site=site,otherid=otherid,name=name,status=0)
            _id = Tb().insert(val,saft=True)
            val['_id'] = str(_id)
            return True,val
    except Exception as e:
        return False,e.message

