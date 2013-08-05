# -*- coding:utf-8 -*- 
"""
    author comger@gmail.com
"""
from pyquery import PyQuery as pyq
from tornado import httpclient
from spiders import ListNode,register
import urllib2 
import tornado

@register('baidunews')
class BaiduNewsListNode(ListNode):

    def __init__(self,page_count=0,page_size=20,**kwargs):
        self._count = page_count
        self._size = page_size
        self._url = 'http://news.baidu.com/ns'
        self._request_params = kwargs
        self.client = httpclient.AsyncHTTPClient()


    def on_parse(self,resp):
        if resp.code == 200:
            body = resp.body.decode('gbk')
            doc = pyq(body)
            items = doc('#r table')
            lst = []
            for item in items:
                _item = pyq(item)
                _news = {}
                _news['title'] = _item('.text b').text()
                _news['source'] = _item('font nobr').html()
                _news['body'] = _item('font[size="-1"]').text()
                _news['url'] = pyq(_item('.text a')[0]).attr('href')
                lst.append(_news)

            self._callback(lst)



    def param_parse(self,**kwargs):
        params = {'tn':'news','ie':'gb2312'}
        params['word'] = urllib2.quote(kwargs.get('city',''))
        params['pn'] = int(kwargs.get('index','0'))*10
        params['rn'] = int(kwargs.get('size','20')) 
        self._size = params['pn']

        return params
