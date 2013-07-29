#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    report action
    author comger@gmail.com
"""

from kpages import url
from utility import ActionHandler
from logic.report import add,TName as T_REPORT
from logic.utility import *

@url(r"/admin/report")
class ReportHandler(ActionHandler):
    def get(self):
        since = self.get_argument("since", None)
        pid = self.get_argument('pid',None)
        cond = {}
        if pid:
            cond = dict(pid = pid)
        r,v = m_page(T_REPORT,since,**cond)
        self.render("admin/report.html", data = v,pid = pid)


@url(r'/admin/report/info/(.*)')
class ReportInfoHandler(ActionHandler):
    def get(self,_id):
        r,info = m_info(T_REPORT,_id)
        self.write(dict(status = r,data = info))


@url(r"/admin/report/save")
class ReportSaveHandler(ActionHandler):
    def post(self):
        _id = self.get_argument("id", None)
        title = self.get_argument("rtitle", None)
        pid = self.get_argument("pid", None)
        body = self.get_argument("body", None)
        tags = self.get_argument("tags", '').split('|')
        seo=self.get_seo_params()

        if not _id:
            r,v = add(title,pid, body, tags = tags, seo = seo)
            self.write(dict(status = r, data =v ))
        else:
            cond = {}
            if title:cond.update(title=title)
            if body:cond.update(body=body)
            if seo:cond.update(seo=seo)
            if len(tags)>0:cond.update(tags=tags)

            r = m_update(T_REPORT,_id, **cond)
            self.write(dict(status = r))

    def get(self):
        _id = self.get_argument("id", None)
        pid = self.get_argument("pid", None)
        isseo = self.get_argument("isseo", '0')

        info = dict(pid = pid)
        if _id:
            r,info = m_info(T_REPORT,_id)

        temp = 'admin/reportinfo.html'
        if isseo == '1':
            temp = 'admin/reportseoinfo.html'
        self.render(temp, info = info)


@url(r"/admin/report/delete")
class ReportDeleteHandler(ActionHandler):
    def post(self):
        _id = self.get_argument("id", None)
        r,v = m_del(T_REPORT,_id)
        self.write(dict(status = r))


