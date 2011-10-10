require 'rbconfig/load_wedge'
require 'rbconfig'

# The Ruby Wedge allows standaard libray scripts to be loaded in a isolated
# fashion.
#
#   require 'optparse', :from=>'ruby'
#
# The example would load optparse standard library regardless of Gem installed
# that might have a script by the same name.

class RbConfig::RubyWedge < RbConfig::LoadWedge

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

$LOAD_WEDGE << RbConfig::RubyWedge.new

# Copyright 2010 Thomas Sawyer, Rubyworks (BSD-2-Clause license)
