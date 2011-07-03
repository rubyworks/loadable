--- !ruby/object:Gem::Specification 
name: wedge
version: !ruby/object:Gem::Version 
  prerelease: 
  version: 1.1.0
platform: ruby
authors: 
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2011-07-03 00:00:00 Z
dependencies: 
- !ruby/object:Gem::Dependency 
  name: detroit
  prerelease: false
  requirement: &id001 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
  type: :development
  version_requirements: *id001
description: |-
  The Wedge gem provides an easy to use interface for adding custom
  load managers to Ruby's standard load system (the `load` and `require`
  methods).
  
  In addition, Wedge includes two pre-assembled wedges that prevent 
  load interfence between libraries.
email: transfire@gmail.com
executables: []

extensions: []

extra_rdoc_files: 
- README.rdoc
files: 
- .yardopts
- .ruby
- lib/wedge/gem.rb
- lib/wedge/kernel.rb
- lib/wedge/ruby.rb
- lib/wedge/version.rb
- lib/wedge.rb
- test/fixture/abbrev.rb
- test/wedge.rb
- HISTORY.rdoc
- BSD-2.txt
- README.rdoc
- COPYING.rdoc
- INFRACTIONS.rdoc
homepage: http://github.com/rubyworks/wedge
licenses: 
- Apache 2.0
post_install_message: 
rdoc_options: 
- --title
- Wedge API
- --main
- README.rdoc
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
required_rubygems_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
requirements: []

rubyforge_project: wedge
rubygems_version: 1.8.2
signing_key: 
specification_version: 3
summary: Safely Customize Ruby's Load System
test_files: []

