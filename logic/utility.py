# -*- coding:utf-8 -*- 

class BaseLogic(object):
    name = None

    @staticmethod
    def get_db(cls):
        return get_context().get_mongo()[name]

    @staticmethod
    def page(cls,index=0,size=10,**cond):
        cond.update(status=0)
        lst = list(tb().find(cond).skip(index*size).limit(size))
        return mongo_conv(lst)
