require 'loadable/mixin'
require 'loadable/core_ext/rubygems'

module Loadable

  # The original loader is simply an encpsulation of the Ruby's
  # built-in #require and #load functionality. This load wedge is
  # thus the first placed of the $LOADER list and the final 
  # fallback if no other loader succeeds.
  #
  class OriginalLoader

    include Loadable

    alias_method :original_load, :load
    alias_method :original_require, :require

    #
    def call(fname, options={})
      if options[:load]
        original_load(fname, options[:wrap])
      else
        original_require(fname)
      end
    end

    # Iterate over each requirable file. Since RubyGems has become
    # a standard part of Ruby as of 1.9, this includes active and latest
    # versions of inactive gems.
    #
    # NOTE: in older versions of RubyGems, activated gem versions are in
    # the $LOAD_PATH too. This may cause some duplicate iterations.
    #
    def each(options={}, &block)
      each_loadpath(&block)
      each_rubygems(&block)
      self
    end

  private

    #
    def each_loadpath(options={}, &block)
      $LOAD_PATH.uniq.each do |path|
        path = File.expand_path(path)
        traverse(path, &block)
      end
    end

    #
    def each_rubygems(options={}, &block)
      return unless defined?(::Gem)
      Gem::Specification.current_specs.each do |spec|
        spec.require_paths.each do |require_path|
          path = File.join(spec.full_gem_path, require_path)
          traverse(path, &block)
        end
      end
    end

  end

end
