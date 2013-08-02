#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    product craw spider 
"""
import os
import re
import tornado
import urllib2
import time

from tornado import httpclient
from inspect import isclass, ismethod, getmembers
from multiprocessing import Pool
from kpages import get_members

class BaseSpider(object):
    name = 'spider'

    def fetch(self,url,**kwargs):
        res = httpclient.HTTPClient().fetch(url)
        self.on_parse(res)
    
    def async_fetch(self, url, callback = None,**kwargs):
        self.callback = callback
        httpclient.AsyncHTTPClient().fetch(url,callback=self.on_parse,**kwargs)
        tornado.ioloop.IOLoop.instance().start() 
   
    def on_callback(self,status, data = None):
        
        if not status:
            self.callback(dict(status = status,data = data))

        if not self.callback:
            return data
        else:
            self.callback(data)

    def map(self, urls, callback = None, **kwargs):
        urls = list(set(urls))
        urls.sort()
        http = httpclient.AsyncHTTPClient()
        
        self.results = []
        self.index = 0
        def on_results(lst):
            self.results.extend(lst)
            self.index = self.index +1
            if self.index == len(urls):
                callback(self.results)
                self.results = []
                self.index =0
                #tornado.ioloop.IOLoop.instance().stop()
        
        self.callback = on_results
        for url in urls:
            print url
            http.fetch(url, callback = self.on_parse,**kwargs)
        
        tornado.ioloop.IOLoop.instance().start()


    def map_url(self, fn, args, pnum = 0):
        if pnum == 0:pnum = len(args)
        p = Pool(pnum)
        return p.map(fn,args)

    def on_parse(self, response):
        raise NotImplementedError()


def valid(host,expre):
    """
        自动适配选择使用
        @valid('http://www.baidu.com/(.*).html')
        class DemoSpider(BaseSpider):
            pass
    """
    def actual(handler):
        if not isclass(handler) or not issubclass(handler, BaseSpider):
            raise Exception("must be BaseSpider's sub class.")

        if not hasattr(handler, "__expre__"): handler.__expre__ = expre
        if not hasattr(handler, "__host__"): handler.__host__ = host

        return handler

    return actual



class ListNode(object):
    @property
    def name(self):
        ''' get node's name '''
        raise NotImplementedError()

    def demo_url(self):
        raise NotImplementedError()

    def standard_structure(self):
        raise NotImplementedError()

    def page_count(self):
        ''' get source's page count '''
        raise NotImplementedError()

    def page_size(self):
        ''' get source's page size '''
        raise NotImplementedError()

    def page(self,callback=None,pageindex=0,**kwargs):
        ''' get pageindex's data '''
        raise NotImplementedError()

    def is_ok(self):
        ''' check node is ok '''
        raise NotImplementedError()

    def param_parse(self,**kwargs):
        return kwargs

    def fetch(self,url,callback=None,**kwargs):
        httpclient.AsyncHTTPClient().fetch(url,callback=callback,**kwargs)

class Loader(object):
    '''
        Spider 加载器, 自动选择或指定Spider 采集数据
    '''
    def __init__(self):
        self.spiders = []
        self.names = []
        self._load()

    def _load(self):
        spider_root = __conf__.SPIDER_DIR
        spders = {}
        if os.path.exists(spider_root):
            spiders = get_members(spider_root,
                    member_filter = lambda o:isclass(o) and issubclass(o, BaseSpider))

        del spiders['spiders.BaseSpider']
        self.spiders = []
        #[(re,__expre__,cls)...]
        for name,cls in spiders.items():
            self.spiders.append((re.compile(cls.__expre__),cls.__expre__,cls))
    
    def get_test_reports(self,tags):
        pass
    
    def run_spider(self, spidertags=(),cron=None):
       pass

    def register(self,tag):
        pass


spiderloader = Loader()
