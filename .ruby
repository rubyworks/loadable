--- 
name: wedge
title: Wedge
contact: trans <transfire@gmail.com>
requires: 
- group: 
  - build
  name: syckle
  version: 0+
resources: 
  "": git://github.com/rubyworks/wedge.git
  home: http://rubyworks.github.com/wedge
pom_verison: 1.0.0
manifest: 
- .ruby
- lib/wedge/gem.rb
- lib/wedge/kernel.rb
- lib/wedge/ruby.rb
- lib/wedge/version.rb
- lib/wedge/version.yml
- lib/wedge.rb
- test/fixture/abbrev.rb
- test/wedge.rb
- HISTORY.rdoc
- LICENSE
- README.rdoc
- VERSION
version: 1.0.1
suite: rubyworks
copyright: Copyright (c) 2010 Thomas Sawyer
licenses: 
- Apache 2.0
description: Wedge makes it easy to write custom loaders.
summary: Customize The Load
authors: 
- Thomas Sawyer
created: 2010-07-21
