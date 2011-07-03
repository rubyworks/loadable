--- 
name: wedge
version: 1.1.0
title: Wedge
summary: Safely Customize Ruby's Load System
description: |-
  The Wedge gem provides an easy to use interface for adding custom
  load managers to Ruby's standard load system (the `load` and `require`
  methods).
  
  In addition, Wedge includes two pre-assembled wedges that prevent 
  load interfence between libraries.
loadpath: 
- lib
manifest: MANIFEST
requires: 
- name: detroit
  version: 0+
  group: 
  - build
conflicts: []

replaces: []

engine_check: []

contact: trans <transfire@gmail.com>
created: "2010-07-21"
copyright: "Copyright:: (c) 2001 Thomas Sawyer"
licenses: 
- Apache 2.0
authors: 
- Thomas Sawyer
maintainers: []

resources: 
  home: http://github.com/rubyworks/wedge
  code: http://github.com/rubyworks/wedge
  mail: http://groups.google.com/group/rubyworks-mailinglist
repositories: 
  public: git://github.com/rubyworks/wedge.git
spec_version: 1.0.0
