#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
    taobao item spider
"""
from pyquery import PyQuery as pyq
from spiders import BaseSpider,valid
import json


HOSTS = ['180.149.135.239','123.125.104.245','120.203.214.172','120.203.215.4','111.1.36.2','117.144.231.206','117.144.231.202','111.1.36.4','111.1.36.5']

@valid('http://s.weibo.com/weibo/',r'(.*)&category=4')
class WeiboSpider(BaseSpider):
    name = 'weibo'
    
    def __init__(self):
        pass

    def on_parse(self, response):
        rs = []
        try:
            body = response.body
            doc = pyq(body)
            scs = doc('script')
            data = json.loads(scs[13].text[41:-1])
            doc = pyq(data.get('html'))
            dls = doc('dl')
            
            for dl in dls:
                item = {}
                item['mid'] = pyq(dl).attr('mid')
                if not item['mid']:
                    continue

                item['author'] = pyq(dl)('p a').attr('nick-name')
                item['body'] = pyq(dl)('p em').text()
                item['html'] = pyq(dl)('.content').html()
                rs.append(item)
            
            self.on_callback(True,rs)
        except Exception as e:
            self.on_callback(False,e)


@valid('http://s.weibo.com/user/?tag=',r'(.*)')
class WeiboUserSpider(BaseSpider):
    name = 'weibouser'
    
    def __init__(self):
        pass

    def on_parse(self, response):
        rs = []
        try:
            body = response.body

            doc = pyq(body)
            scs = doc('script')

            data = json.loads(scs[7].text[41:-1])
            doc = pyq(data.get('html'))
            dls = doc('.list_person')
            
            for dl in dls:
                item = {}
                link = pyq(dl)('.person_name a')
                item['uid'] = pyq(link).attr('uid')
                if not item['uid']:
                    continue

                item['info'] = pyq(pyq(dl)('.person_info')).text()
                item['author'] = pyq(link).attr('title')
                item['html'] = pyq(dl)('.person_detail').html()
                rs.append(item)
        
            self.on_callback(True,rs)
        except Exception as e:
            self.on_callback(False, e)



