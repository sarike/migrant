#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    logic for account
"""
from kpages import not_empty
from bson.objectid import ObjectId
from utility import page

tb = lambda:get_context().getmongo()["account"]

def add(username,password,city,**kwargs):
    try:
        not_empty(username,password,city)
        val = dict(username=username,password=password,city=city,status=0)
        val.update(kwargs)
        _id = tb().insert(val,saft=True)
        val['_id'] = str(_id)
        return True,val
    except Exception as e:
        return False,e.message


def update(_id,**kwargs):
    try:
        not_empty(_id)
        tb().update(dict(_id=ObjectId(_id),status=0),{"$set",kwargs})
        return True
    except Exception as e:
        return False,e.message

__all__ = ["page"]
