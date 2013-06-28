#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    logic for account
"""
from kpages import not_empty

def add(username,password,city,**kwargs):
    not_empty(username,password,city)

