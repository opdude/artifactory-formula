# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "artifactory/map.jinja" import artifactory with context %}

artifactory-service:
  service.running:
    - name: artifactory
    - enable: True
