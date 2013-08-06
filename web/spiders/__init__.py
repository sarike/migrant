#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    product craw spider 
"""
import os
import tornado
import urllib2
import time

from tornado import httpclient
from inspect import isclass, ismethod, getmembers
from kpages import get_members


def register(nodename):
    """
        @register('demonode')
        class DemoSpider(ListNode):
            pass
    """
    def actual(handler):
        if not isclass(handler) or not issubclass(handler, ListNode):
            raise Exception("must be ListNode's sub class.")

        if not hasattr(handler, "__nodename__"): handler.__nodename__ = nodename

        return handler

    return actual


class ListNode(object):
    _size = 0
    _count = 0
    _url = None
    _status = False
    _request_params = {}
    _callback = lambda resp:resp.code

    def standard_structure(self):
        raise NotImplementedError()

    def page(self,callback=None,**kwargs):
        self._callback = callback or self._callback
        kwargs = self.param_parse(**kwargs)
        url = self._make_url(kwargs)
        print url
        self.client.fetch(url,callback=self.on_parse,**self._request_params)
    
    def is_ok(self):
        ''' check node is ok '''
        raise NotImplementedError()

    def param_parse(self,**kwargs):
        return kwargs

    def _make_url(self,params):
        url = self._url +"?"
        for key in params.keys():
            url = '{0}{1}={2}&'.format(url,key,params[key])
        return url
    
            

class Loader(object):
    '''
        Spider 加载器, 自动选择或指定Spider 采集数据
    '''
    def __init__(self):
        self.spiders = {}
        self._load()

    def _load(self):
        spider_root = __conf__.SPIDER_DIR
        spders = {}
        if os.path.exists(spider_root):
            spiders = get_members(spider_root,
                    member_filter = lambda o:isclass(o) and issubclass(o, ListNode))

        del spiders['spiders.ListNode']
        self.spiders = {}
        for name,cls in spiders.items():
            self.spiders[cls.__nodename__] = cls
    
    def get_test_reports(self,tags):
        pass
    
    def run_spider(self, spidertags=(),cron=None):
       pass

    def register(self,tag):
        pass


spiderloader = Loader()
