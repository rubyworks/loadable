# Use the Ruby wedge too so standard libs can be treated in the
# same manner.

require 'load/ruby'

# The Gem Wedge allows gem files to be loaded in a isolated fashion.
#
#   require 'tracepoint', :from=>'tracepoint'
#
# The example would load the tracepoint file from the tracepoint gem.

class Load::GemWedge < Load::Wedge

  # TODO: If :gem AND :from options are given, perhaps try both
  # instead either-or?

  #
  def call(fname, options={})
    return unless options[:from] or options[:gem]

    gem_name = (options[:gem] || options[:from]).to_s
    gem_file = fname

    gem_file = gem_name if gem_file.empty?

    gem(gem_name)

    gem_spec = Gem.loaded_specs[gem_name]

    file = nil
    file ||= Gem.searcher.matching_files(gem_spec, gem_file).first
    file ||= Gem.searcher.matching_files(gem_spec, File.join(gem_name, gem_file)).first

    if file
      super(file, options)
    else
      raise_load_error(fname)
    end
  end

end

Load::Wedge.register(Load::GemWedge.new)

=begin log
2011-10-09 trans:
  - Namespace changed from Wedge to Load::Wedge.
  - Deprecated use of colon notation (e.g. require 'ruby:optparse')
    in favor of :gem/:from options (e.g. require 'functor', :from=>'facets').
=end

# Copyright 2010 Thomas Sawyer, Rubyworks (BSD-2-Clause license)
