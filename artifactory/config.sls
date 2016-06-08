# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "artifactory/map.jinja" import artifactory with context %}

{{ artifactory.home }}/etc/storage.properties:
  file.managed:
    - source: salt://artifactory/conf/mysql.properties
    - template: jinja