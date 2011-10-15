# Use the Ruby wedge too so standard libs can be treated in the
# same manner.

require 'rbconfig/ruby_wedge'

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

class RbConfig::GemWedge < RbConfig::LoadWedge

  # TODO: If :gem AND :from options are given, perhaps try both
  # instead of either-or?

  # TODO: Support gem version constraints.

  # Determine if this load wedge is applicable given the +fname+
  # and +options+.
  #
  def apply?(fname, options={})
    return true if options[:gem]
    return true if options[:from] &&
      Gem::Specification.all_names.include?(options[:from].to_s)
    return false
  end

  # Load script from specific gem.
  #
  # Returns +nil+ if this loader is not applicable, which is determined
  # by the use of `:gem => 'foo'` or `:from => 'foo'` options.
  #
  def call(fname, options={})
    return unless apply?(fname, options)

    file = find(fname, options).first

    if file
      super(file, options)
    else
      raise_load_error(fname)
    end
  end

  # Returns first matching script.
  #
  # Returns +nil+ if this loader is not applicable, which is determined
  # by the use of `:gem => 'foo'` or `:from` => 'foo'` options.
  #
  def find(glob, options={})
    return unless apply?(fname, options)

    gem_name = (options[:gem] || options[:from]).to_s
    gem_glob = glob

    return unless Gem::Specification.all_names.include?(gem_name)

    gem(gem_name)

    gem_spec = Gem.loaded_specs[gem_name]

    #if gem_spec
      return Gem.searcher.matching_files(gem_spec, gem_file).first ||
             Gem.searcher.matching_files(gem_spec, File.join(gem_name, gem_file)).first
    #end
  end

end

$LOAD_WEDGE << RbConfig::GemWedge.new

# Copyright 2010 Thomas Sawyer, Rubyworks (BSD-2-Clause license)
