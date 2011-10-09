require 'load/wedge'
require 'rbconfig'

# The Ruby Wedge allows standaard libray scripts to be loaded in a isolated
# fashion.
#
#   require 'optparse', :from=>'ruby'
#
# The example would load optparse standard library regardless of Gem installed
# that might have a sciipt by the same name.

Load::Wedge.new :Ruby do

  # Notice that rubylibdir takes precendence.
  LOCATIONS = ::RbConfig::CONFIG.values_at(
    'rubylibdir', 'archdir', 'sitelibdir', 'sitearchdir'
  )

  # TODO: Maybe add support more refined selection of locations.

  #
  def call(file, options={})
    return unless options[:from].to_s == 'ruby'

    LOCATIONS.each do |loadpath|
      if path = find(loadpath, file, options)
        return super(path, options)
      end
    end

    raise LoadError, "no such file to load -- #{fname}"
  end

end


=begin log
- 2011-10-09 trans:
  - Namespace changed from Wedge to Load::Wedge.
  - Deprecated use of colon notation (e.g. require 'ruby:optparse')
    in favor of 'from' option (e.g. require 'optparse', :from=>'ruby').
=end

# Copyright 2010 Thomas Sawyer, Rubyworks (BSD-2-Clause license)
