#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""
    author comger@gmail.com
    google spider
"""
from pyquery import PyQuery as pyq
from spiders import BaseSpider,valid
import json


DELETE_WORDS = ['动词','名词','形容词','zh-CN']

@valid('http://translate.google.cn/translate_a/t?client=t&hl=zh-CN&sl=zh-CN&tl=en&q=',r'(.*)')
class GoogleSpider(BaseSpider):
    name = 'google'
    
    def __init__(self):
        pass

    def on_parse(self, response):
        rs = []
        try:
            
            body = response.body
            body = body.replace('[','').replace(']','').replace('"','')
            arr = body.split(',')
            for i in arr:
                if is_chinese(i) and not is_number(i) and len(i)>0 and  not i in DELETE_WORDS:
                    rs.append(i)
            
            rs = list(set(rs))
            self.on_callback(True,rs)
        except Exception as e:
            self.on_callback(False,e)



def is_number(uchar):
    try:
        i = float(uchar)
        return True
    except:
        return False

def is_chinese(uchar):
    return uchar >= u'\u4e00' and uchar<=u'\u9fa5'

def is_alphabet(uchar):
    return (uchar >= u'\u0041' and uchar<=u'\u005a') or (uchar >= u'\u0061' and uchar<=u'\u007a')
