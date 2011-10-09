# The Gem Wedge allows gem files to be loaded in a isolated fashion.
#
#   require 'tracepoint:tracepoint'
#
# The example would load the tracepoint file from the tracepoint gem.

# Load wedge via wedge/ruby. The Ruby wedge provides
# a way to treat ruby standard libs as if they were a gem.
require 'wedge/ruby'

Wedge.new :Gem do

  #
  def call(fname, options={})
    return unless md = /(\w+):/.match(fname)

    gem_name = md[1]
    gem_file = md.post_match

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

