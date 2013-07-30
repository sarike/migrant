#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
    account action
    author comger@gmail.com
"""

from kpages import url
from utility import ActionHandler
from logic.account import login,page,add,TName as T_ACCOUNT
from logic.utility import m_update,m_del,m_info


@url(r"/admin/?")
class AdminHandler(ActionHandler):
    def get(self):
        self.render('admin/index.html')


@url(r"/admin/help")
class HelpHandler(ActionHandler):
    def get(self):
        self.render('admin/help.html')


@url(r"/admin/account")
class AccountHandler(ActionHandler):
    def get(self):
        since = self.get_argument("since", None)
        key = self.get_argument("key", None)
        cond = {}
        if key:
            cond = {'username':{'$regex':key}}
        r,v = page(since,**cond)
        self.render("admin/account.html", data = v)


@url(r"/admin/account/save")
class AccountSaveHandler(ActionHandler):
    def post(self):
        _id = self.get_argument("id", None)
        username = self.get_argument("username", None)
        password = self.get_argument("password", None)
        email = self.get_argument("email", None)
        tel = self.get_argument("tel", '')
        city = self.get_argument("city", '')
        isadmin = bool(self.get_argument('isadmin','True'))

        cond = dict(email = email, tel = tel, isadmin = isadmin,city=city)
        if not _id:
            r,v = add(username, password, **cond)
            #self.write(dict(status = r, data =v ))
        else:
            r,v = m_update(T_ACCOUNT,_id, **cond)
            #self.write(dict(status = r))
        self.redirect('/admin/account')

    def get(self):
        _id = self.get_argument("id", None)
        info = {}
        if _id:
            r,info = m_info(T_ACCOUNT,_id)

        self.render('admin/accountinfo.html', info = info)

@url(r"/admin/account/delete")
class AccountDeleteHandler(ActionHandler):
    def post(self):
        _id = self.get_argument("id", None)
        r,v = m_del(T_ACCOUNT,_id)
        self.write(dict(status = r, data = v))



@url(r"/admin/login")
class LoginHandler(ActionHandler):
    def get(self):
        self.render('admin/login.html',errormsg = '',next = self.get_argument('next','/admin'))

    def post(self):
        username = self.get_argument("username", None)
        password = self.get_argument("password", None)

        r,v = login(username, password,True)

        if r:
            self.set_secure_cookie("admin_user_name", username)
            self.signin_admin(v['_id'])
        else:
            self.render('admin/login.html', errormsg = '登录失败')



@url(r"/admin/account/setpassword")
class SetPwdHandler(ActionHandler):
    def get(self):
        self.render('admin/setpassword.html',errormsg = '')

    def post(self):
        username = self.get_argument("username", None)
        password = self.get_argument("oldpassword", None)
        newpassword = self.get_argument("password", None)

        r,v = login(username, password,True)
        if r:
            r,v = m_update(T_ACCOUNT,v['_id'],password=newpassword)
            v = '密码修改成功'
        else:
            v = '密码错误'

        self.render('admin/setpassword.html',errormsg = v)    

@url(r"/admin/logout")
class LogoutHandler(ActionHandler):
    def get(self):
        self.signout_admin()
