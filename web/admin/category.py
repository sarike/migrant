#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    category action
    author comger@gmail.com
"""

from kpages import url
from utility import ActionHandler
from logic.category import add,TName as T_CATEGORY
from logic.group import TName as T_GROUP
from logic.pinying import get_pinyin
from logic.utility import m_page,m_del,m_info,m_update

@url(r"/admin/category/find")
class CategoryFindHandler(ActionHandler):
    def get(self):
        groupid = self.get_argument('groupid',None)
        cond = dict(groupid = groupid)
        r,cates = m_page(T_CATEGORY,**cond)
        self.write(dict(status = r,categorys = cates))


@url(r"/admin/category")
class CategoryHandler(ActionHandler):
    def get(self):
        since = self.get_argument("since", None)
        groupid = self.get_argument('groupid',None)
        cond = {}
        if groupid:
            cond = dict(groupid = groupid)
        
        r,groups = m_page(T_GROUP,size=100)
        r,cates = m_page(T_CATEGORY,**cond)
        self.render("admin/category.html", data = cates, groups = groups, groupid = groupid)



@url(r'/admin/category/info/(.*)')
class CategoryInfoHandler(ActionHandler):
    def get(self,_id):
        r,info = m_info(T_CATEGORY,_id)
        self.write(dict(status =r,data = info))


@url(r"/admin/category/save")
class CategorySaveHandler(ActionHandler):
    def post(self):
        _id = self.get_argument("id", None)
        name = self.get_argument("name", None)
        logo = self.get_argument("logo", None)
        groupid = self.get_argument("groupid", None)
        listname = self.get_argument("listname", None)
        intro = self.get_argument("intro", None)
        tags = self.get_argument("tags", '').split('|')
        
        if not listname:
            listname = get_pinyin(name)

        if not _id:
            r,v = add(name, groupid,listname,intro, logo = logo, tags = tags ,seo = self.get_seo_params())
            self.write(dict(status = r, data =v ))
        else:
            r,v = m_update(T_CATEGORY,_id, name = name, groupid = groupid, listname = listname, intro = intro,logo = logo, tags = tags, seo = self.get_seo_params())
            self.write(dict(status = r,data = v))

    def get(self):
        _id = self.get_argument("id", None)
        info = {}
        if _id:
            r,info = m_info(T_CATEGORY,_id)

        self.render('admin/categoryinfo.html', info = info)

@url(r"/admin/category/delete")
class CategoryDeleteHandler(ActionHandler):
    def post(self):
        _id = self.get_argument("id", None)
        r,v = m_delete(T_CATEGORY,_id)
        self.write(dict(status = r,data = v))





