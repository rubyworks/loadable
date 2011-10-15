---
authors:
- name: Thomas Sawyer
  email: transfire@gmail.com
copyrights:
- holder: Thomas Sawyer, RubyWorks
  year: '2010'
  license: BSD-2-Clause
replacements: []
conflicts: []
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
repositories:
- uri: git://github.com/rubyworks/loadable.git
  scm: git
  name: upstream
resources: {}
load_path:
- lib
extra: {}
source:
- Profile
alternatives: []
revision: 0
created: '2010-07-21'
summary: Safely Customize Ruby's Load System
title: Loadable
name: loadable
version: 1.2.0
description: Loadable modifieds Ruby's load/require system to handle "load wedges",
  which work much like routes in web frameworks, but in this case determine which
  files get loaded.
date: '2011-10-15'
