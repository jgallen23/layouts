#!/usr/bin/env python

import cgi

f = open('layouts.applescript');
script = f.read();
script = cgi.escape(script);
f.close();
script = script.replace('\n', '\r')

f = open('alfred/template.plist');
info = f.read();
f.close();
info = info.replace('{{script}}', script);

f = open('alfred/out/info.plist', 'w');
f.write(info)
f.close();
