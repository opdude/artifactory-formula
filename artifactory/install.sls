# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "artifactory/map.jinja" import artifactory with context %}

{% if artifactory.pro %}
{% set pkg = "jfrog-artifactory-pro" %}
{% else %}
{% set pkg = "jfrog-artifactory" %}
{% endif %}

{% set jar = "mysql-connector-java-" + artifactory.mysql.jdbc_version + ".jar" %}

python-software-properties:
  pkg.installed

artifactory-repo:
  pkgrepo.managed:
    - humanname: Artifactory
    - name: deb https://jfrog.bintray.com/artifactory-pro-debs trusty main
    - file: /etc/apt/sources.list.d/artifactory.list
    - key_url: https://bintray.com/user/downloadSubjectPublicKey?username=jfrog
    - require_in:
      - pkg: artifactory-pkg

oracle-ppa:
  pkgrepo.managed:
    - humanname: WebUpd8 Oracle Java PPA repository
    - ppa: webupd8team/java
    - file: /etc/apt/sources.list.d/oracle.list
    - keyid: EEA14886
    - keyserver: keyserver.ubuntu.com
    - require:
      - pkg: python-software-properties
    - require_in:
      - pkg: artifactory-pkg

oracle-license-select:
  cmd.run:
    - unless: which java
    - name: '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections'
    - require_in:
      - pkg: oracle-java8-installer
      - cmd: oracle-license-seen-lie

oracle-license-seen-lie:
  cmd.run:
    - name: '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true  | /usr/bin/debconf-set-selections'
    - require_in:
      - pkg: oracle-java8-installer

oracle-java8-installer:
  pkg:
    - installed
    - require:
      - pkgrepo: oracle-ppa

jdbc-driver:
  file.managed:
    - name: {{ artifactory.home }}/tomcat/lib/{{ jar }}
    - makedirs: True
    - source: http://repo.jfrog.org/artifactory/remote-repos/mysql/mysql-connector-java/{{ artifactory.mysql.jdbc_version }}/{{ jar }}
    - source_hash: md5=30111a9076c1a8f581d8bb2243053efc

artifactory-pkg:
  pkg.installed:
    - name: {{ pkg }}
    - require:
      - pkg: python-software-properties
