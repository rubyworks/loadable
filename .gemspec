--- !ruby/object:Gem::Specification 
name: wedge
version: !ruby/object:Gem::Version 
  hash: 21
  prerelease: false
  segments: 
  - 1
  - 0
  - 1
  version: 1.0.1
platform: ruby
authors: 
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2010-12-13 00:00:00 -05:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: syckle
  prerelease: false
  requirement: &id001 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        hash: 3
        segments: 
        - 0
        version: "0"
  type: :development
  version_requirements: *id001
description: Wedge makes it easy to write custom loaders.
email: transfire@gmail.com
executables: []

extensions: []

extra_rdoc_files: 
- README.rdoc
files: 
- .ruby
- lib/wedge/gem.rb
- lib/wedge/kernel.rb
- lib/wedge/ruby.rb
- lib/wedge/version.rb
- lib/wedge.rb
- test/fixture/abbrev.rb
- test/wedge.rb
- HISTORY.rdoc
- LICENSE
- README.rdoc
- VERSION
has_rdoc: true
homepage: http://rubyworks.github.com/wedge
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
      hash: 3
      segments: 
      - 0
      version: "0"
required_rubygems_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      hash: 3
      segments: 
      - 0
      version: "0"
requirements: []

rubyforge_project: wedge
rubygems_version: 1.3.7
signing_key: 
specification_version: 3
summary: Customize The Load
test_files: []

