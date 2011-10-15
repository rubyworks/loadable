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
- name: minitap
  groups:
  - test
  development: true
dependencies: []
repositories:
- uri: git://github.com/rubyworks/loadable.git
  scm: git
  name: public
resources: {}
load_path:
- lib
extra:
  manifest: MANIFEST
source:
- meta
alternatives: []
revision: 0
created: '2010-07-21'
summary: Safely Customize Ruby's Load System
title: Loadable
name: loadable
version: 1.1.0
description: ! "The Loader gem provides an easy to use interface for adding custom\nload
  managers to Ruby's standard load system, namely the `load` \nand `require` methods.\n\nIn
  addition, it includes two pre-assembled load wedges that prevent \nload interference
  between ruby's standard library and gem packages\n(see INFRACTIONS.rdoc)."
date: '2011-10-15'
