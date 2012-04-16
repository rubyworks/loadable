---
source:
- Profile
- var
authors:
- name: Thomas Sawyer
  email: transfire@gmail.com
copyrights:
- holder: Thomas Sawyer, RubyWorks
  year: '2010'
  license: BSD-2-Clause
requirements:
- name: detroit
  groups:
  - build
  development: true
- name: minitest
  groups:
  - test
  development: true
- name: minitap
  groups:
  - test
  development: true
- name: rake
  groups:
  - build
  development: true
dependencies: []
alternatives: []
conflicts: []
repositories:
- uri: git://github.com/rubyworks/loadable.git
  scm: git
  name: upstream
resources:
- uri: http://rubyworks.github.com/loadable
  name: home
  type: home
- uri: http://github.com/rubyworks/loadable
  name: code
  type: code
- uri: http://rubydoc.info/github/rubyworks/loadable/master/frames
  name: docs
  type: docs
- uri: http://groups.google.com/group/rubyworks-mailinglist
  name: mail
  type: mail
- uri: irc://irc.freenode.net/rubyworks
  name: chat
  type: chat
extra: {}
load_path:
- lib
revision: 0
created: '2010-07-21'
summary: Safely Customize Ruby's Load System
title: Loadable
version: 1.2.0
name: loadable
description: Loadable modifieds Ruby's load/require system to handle "load wedges",
  which work much like routes in web frameworks, but in this case determine which
  files get loaded.
date: '2012-04-16'
