# -*- coding:utf-8 -*-
"""
    author comger@gmail.com
    sync user from server to openfire
"""
from tornado import httpclient
from tornado.httputil import url_concat
from kpages import not_empty


client = httpclient.AsyncHTTPClient()


def _make_url(params):
    url = '{0}/plugins/userService/userservice?secret={1}'.format(
        __conf__.XMPP_HOST, __conf__.XMPP_SECRET)
    for key in params.keys():
        if not params[key]:
            del params[key]

    return url_concat(url, params)


def add(username, password, name, email=None, group=None, callback=None):
    ''' 添加一个用户到openfire '''
    not_empty(username, password, name)
    val = dict(type='add', username=username,
               password=password, name=name, email=email, group=group)
    url = _make_url(val)
    return client.fetch(url, callback=callback)


def update(username, password=None, name=None, email=None, group=None, callback=None):
    ''' 修改用户息 '''
    not_empty(username)
    val = dict(type='update', username=username,
               password=password, name=name, email=email, group=group)
    url = _make_url(val)
    print url
    return client.fetch(url, callback=callback)


def userstatus(username, enable=True, callback=None):
    ''' 启用或停用openfire用户'''
    not_empty(username)
    able = 'enable' if enable else 'disable'
    val = dict(type=able, username=username)
    url = _make_url(val)
    return client.fetch(url, callback=callback)

# vim: ts=4 sw=4 sts=4 expandtab
