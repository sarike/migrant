#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    group action
    author comger@gmail.com
"""

from kpages import url
from utility import ActionHandler
from logic.group import add,TName as T_GROUP
from logic.pinying import multi_get_letter,get_pinyin
from logic.utility import *

@url(r"/admin/group")
class GroupHandler(ActionHandler):
    def get(self):
        since = self.get_argument("since", None)
        key = self.get_argument("key", None)
        cond = {}
        if key:
            cond = {'$or':[{'listname':{'$regex':key}},{'name':{'$regex':key}}]}
        r,v = m_page(T_GROUP,since=since,**cond)
        self.render("admin/group.html", data = v)


@url(r'/admin/group/info/(.*)')
class GroupInfoHandler(ActionHandler):
    def get(self,_id):
        r,info = m_info(T_GROUP,_id)
        self.write(dict(status = r,data = info))


@url(r"/admin/group/save")
class GroupSaveHandler(ActionHandler):
    def post(self):
        _id = self.get_argument("id", None)
        name = self.get_argument("name", None)
        intro = self.get_argument("intro", None)
        listname  = self.get_argument("listname", None)
        logo  = self.get_argument("logo", None)

        if not listname:
            listname = get_pinyin(name)
        
        if not _id:
            r,v = add(name,listname,logo = logo,intro = intro, seo = self.get_seo_params())
            self.write(dict(status = r, data =v ))
        else:
            r = m_update(T_GROUP,_id, name = name ,listname = listname,logo = logo,intro = intro ,seo = self.get_seo_params())
            self.write(dict(status = r))

    def get(self):
        _id = self.get_argument("id", None)
        info = {}
        if _id:
            r,info = m_info(T_GROUP,_id)

        self.render('admin/groupinfo.html', info = info)

@url(r"/admin/group/delete")
class GroupDeleteHandler(ActionHandler):
    def post(self):
        _id = self.get_argument("id", None)

        r,v = m_delete(T_GROUP,_id)
        self.write(dict(status = r,data = v))




