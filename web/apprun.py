#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""
    author comger@gmail.com
"""
import sys
import json

from datetime import datetime
from pprint import pprint
from kpages import run


def callback(app):
    '''
        print app config
    '''

    print "Start time: {0}".format(datetime.now().isoformat(" "))
    print "Config Params"
    for k in sorted(app.settings.keys()):
        if k.startswith("__"):
            continue
        print "  {0:<20} : {1}".format(k, app.settings[k])

    print
    print "Router Handlers"
    pprint(app.handlers)

if __name__ == "__main__":
    try:
        run(callback)
    except KeyboardInterrupt:
        print 'exit app '

# vim: ts=4 sw=4 sts=4 expandtab
