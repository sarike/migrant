 #-*- coding:utf-8 -*-
"""
    author comger@gmail.com
    test for openfire user manage
"""
from tornado.httpclient import AsyncHTTPClient
from tornado.testing import AsyncTestCase
from logic.openfireusers import add, userstatus, update
from logic.utility import m_page

class UserCase(AsyncTestCase):

    def test_add(self):
        r,users = m_page('account',size=100)
        for item in users:
            #add(item['username'], item['password'], item['username'], group='bj', callback=self.on_end)
            pass
        

    def test_update(self):
        #update('bcdabab@sos360.com', name='badabab', callback=self.on_end)
        r,users = m_page('account',size=100)
        for item in users:
            update(item['username'],item['username'], group='bj', callback=self.on_end)
        pass

    def test_able(self):
        #userstatus('bcdabab@sos360.com', enable=True, callback=self.on_end)
        #userstatus('bcabab@sos360.com', enable=False, callback=self.on_end)
        pass

    def on_end(self, resp):
        print resp.code, resp.body

# vim: ts=4 sw=4 sts=4 expandtab
