#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    resource action
    author comger@gmail.com
"""
import tornado
from kpages import url,mongo_conv
from utility import ActionHandler
from logic.utility import *
from logic.city import TName as T_CITY
try:
    from spiders import spiderloader
except:
    spiders = None

@url(r"/admin/resource")
class ResourceListHandler(ActionHandler):
    def get(self):
        self.render("admin/resource.html", data = spiderloader.spiders.keys())


@url(r"/admin/resource/(.*)")
class ResourceHandler(ActionHandler):
    @tornado.web.asynchronous
    def get(self,name=None):
        node = spiderloader.spiders.get(name,None)
        if not node:return self.write('未能找到此节点')
        
        self.city = self.get_argument('city',None)
        if not self.city:
            return self.render("admin/resourceitem.html",data =[],city=self.city)

        page = self.get_argument('page','0')
        r,v = m_info(T_CITY,self.city)
        if r:
            node().page(callback=self.on_end,city=v['name'],index=page)
        else:
            self.write('未能找到此城市')
            return self.finish()



    def on_end(self,lst):
        lst = mongo_conv(lst)
        self.render("admin/resourceitem.html",data =lst,city=self.city)
