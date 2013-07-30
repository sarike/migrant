#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    base handler for cas
"""
from kpages import ContextHandler

class ActionHandler(ContextHandler):
    
    uid = property(lambda self: self.get_secure_cookie(self._Admin_user_id))
    username = property(lambda self: self.get_secure_cookie("admin_user_name"))
    _Admin_user_id = '__ADMIN_USER_ID'

    def signin_admin(self, v):
        '''sign in for admin '''
        self.set_secure_cookie(self._Admin_user_id, v)
        url = self.get_argument('next', None)
        if url:self.redirect(url)
    
    def signout_admin(self, redirect_url = "/admin/login"):
        self.clear_cookie(self._Admin_user_id)
        if redirect_url: self.redirect(redirect_url)

    def prepare(self):
        if not self.uid and self.request.uri not in ["/admin/login",]:
            if not self.request.uri.startswith('/admin/login'):
                self.redirect("/admin/login?next="+self.request.uri)

    def get_seo_params(self):
        seo = {}
        seo['keyword'] = self.get_argument('keyword','')
        seo['remark'] = self.get_argument('remark','')
        seo['title'] = self.get_argument('title','')

        return seo

    
    def render(self, template_path, **kwargs):
        super(ActionHandler,self).render(template_path, current_request = self, **kwargs)
