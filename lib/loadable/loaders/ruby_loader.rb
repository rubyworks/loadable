# TODO: Maybe add support more refined selection of locations.

# TODO: Add new vendor locations.

require 'rbconfig'
require_relative '../mixin'

module Loadable

  # The Ruby Wedge allows standaard libray scripts to be loaded in a isolated
  # fashion.
  #
  #   require 'optparse', :from=>'ruby'
  #
  # The example would load optparse standard library regardless of Gem installed
  # that might have a script by the same name.

  class RubyLoader

    include Loadable

    # Notice that rubylibdir takes precendence.
    LOCATIONS = ::RbConfig::CONFIG.values_at(
      'rubylibdir', 'archdir', 'sitelibdir', 'sitearchdir'
    )

    # The `#apply?` methods determines if the load wedge is applicable.
    #
    # Returns +true+ if this loader is not applicable, which is
    # determined by the use of `:from => 'ruby'` option, otherwise `false`.
    #
    def apply?(fname, options={})
      options[:from].to_s == 'ruby'
    end

    # Load the the first standard Ruby library matching +file+.
    #
    # Returns +nil+ if this loader is not applicable, which is
    # determined by the use of `:from => 'ruby'` option.
    #
    def call(file, options={})
      return unless apply?(file, options)

      LOCATIONS.each do |site|
        if path = lookup(site, file, options)
          return super(path, options)
        end
      end

      raise_load_error(fname)
    end

    #
    def each(options={}, &block)
      LOCATIONS.each do |path|
        #path = File.expand_path(path)
        traverse(path, &block)
      end
    end

  private

    # Retun first matching file from Ruby's standard library locations.
    #
    # Returns +nil+ if this loader is not applicable.
    #
    def find(glob, options={})
      return unless apply?(file, options)

      LOCATIONS.each do |site|
        path = lookup(site, file, options)
        return path if path
      end
    end

  end

end

# Copyright 2010 Thomas Sawyer, Rubyworks (BSD-2-Clause license)
