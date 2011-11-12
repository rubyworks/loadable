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
replacements: []
alternatives: []
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
conflicts: []
repositories:
- uri: git://github.com/rubyworks/loadable.git
  scm: git
  name: upstream
resources:
  home: http://rubyworks.github.com/loadable
  code: http://github.com/rubyworks/loadable
  docs: http://rubydoc.info/github/rubyworks/loadable/master/frames
  mail: http://groups.google.com/group/rubyworks-mailinglist
  chat: irc://irc.freenode.net/rubyworks
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
date: '2011-11-11'
