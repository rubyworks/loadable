# TODO: Support colon notation again ?

# TODO: If :gem AND :from options are given, perhaps try both
# instead of either-or?

require 'loadable/mixin'
require 'loadable/core_ext/rubygems'

module Loadable

  # The Gem Wedge allows gem files to be loaded in a isolated fashion.
  #
  #   require 'tracepoint', :from=>'tracepoint'
  #
  # The example would load the tracepoint file from the tracepoint gem.
  # It will also fallback to the RubyWedge if 'tracepoint' is not found
  # among available gems. Loading can be limited to gems only by using
  # the `:gem` options instead.
  #
  #   require 'tracepoint', :gem=>'tracepoint'
  #
  # Now, if the `tracepoint` script is not found among availabe gems,
  # a LoadError will be raised.
  #
  class GemLoader

    include Loadable

    # Load script from specific gem.
    #
    # Returns +nil+ if this loader is not applicable, which is determined
    # by the use of `:gem => 'foo'` or `:from => 'foo'` options.
    #
    def call(fname, options={})
      return unless apply?(fname, options)

      gem_name = options[:gem] || options[:from]

      if vers = options[:version]
        spec = ::Gem::Specification.find_by_name(gem_name, vers)
      else
        spec = ::Gem::Specification.find_by_name(gem_name)
      end

      if options[:gem]
        raise_load_error(fname) unless spec
      else
        return unless spec
      end

      file = spec.find_requirable_file(fname)

      if file
        super(file, options)
      else
        raise_load_error(fname)
      end
    end

    # Iterate over each loadable file in specified gem.
    #
    def each(options={}, &block)
      return unless apply?(nil, options)

      gem_name = (options[:gem] || options[:from]).to_s

      if vers = options[:version]
        spec = ::Gem::Specification.find_by_name(gem_name, vers)
      else
        spec = ::Gem::Specification.find_by_name(gem_name)
      end

      return unless spec

      #spec.activate

      spec.require_paths.each do |path|
        traverse(File.join(spec.full_gem_path, path), &block)
      end
    end

    # Determine if this load4 wedge is applicable given the +fname+
    # and +options+.
    #
    def apply?(fname, options={})
      return true if options[:gem]
      return true if options[:from] && (
        ::Gem::Specification.find{ |s| options[:from].to_s == s.name }
      )
      return false
    end

  end

end

# Copyright 2010 Thomas Sawyer, Rubyworks (BSD-2-Clause license)
