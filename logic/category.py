#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    logic for account
"""
from kpages import not_empty
from bson.objectid import ObjectId
from utility import page

tb = lambda:get_context().getmongo()["category"]

__all__ = ["page"]
