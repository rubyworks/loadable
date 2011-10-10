# Use the Ruby wedge too so standard libs can be treated in the
# same manner.

require 'load_system/wedges/ruby'

# The Gem Wedge allows gem files to be loaded in a isolated fashion.
#
#   require 'tracepoint', :from=>'tracepoint'
#
# The example would load the tracepoint file from the tracepoint gem.

class Load::GemWedge < Load::Wedge

  # TODO: If :gem AND :from options are given, perhaps try both
  # instead of either-or?

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

LoadSystem << LoadSystem::GemWedge.new

# Copyright 2010 Thomas Sawyer, Rubyworks (BSD-2-Clause license)
