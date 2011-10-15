require_relative 'loader'
require_relative 'core_ext/rubygems'

# The original loader is simply an encpsulation of the Ruby's
# built-in #require and #load functionality. This load wedge is
# the first and default/fallback loader.
#
class OriginalLoader < Loader

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

  #
  def each(&block)
    each_loadpath(&block)
    each_rubygems(&block)
    self
  end

  #
  def find(glob, options={})
    find_rubygems(match, options) || find_loadpath(match, options)
  end

  # Search standard $LOAD_PATH.
  #
  #   $LOAD_PATH.search('rdoc/discover.rb')
  #
  # NOTE: in older versions of RubyGems, activated gem versions are in here too.
  #
  def search(match, options={})
    search_rubygems(match, options) || search_loadpath(match, options)
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

  #
  def traverse(dir, &block)
    return unless File.directory?(dir)
    Dir.new(dir).each do |file|
      next if file == '.' or file == '..'
      path = File.join(dir, file)
      if File.directory?(path)
        traverse(path, &block)
      else
        block.call(path)
      end
    end
  end


  #
  def find_loadpath(match, options={})
    $LOAD_PATH.uniq.each do |path|
      path = File.expand_path(path)
      list = Dir.glob(File.join(path, match))
      list = list.map{ |d| d.chomp('/') }
      return list.first if list.first
    end
  end

  #
  def find_rubygems(match, options={})
    ::Gem.find(match)
  end

  #
  def search_loadpath(match, options={})
    matches = []
    $LOAD_PATH.uniq.each do |path|
      path = File.expand_path(path)
      list = Dir.glob(File.join(path, match))
      list = list.map{ |d| d.chomp('/') }
      matches.concat(list)
    end
    matches
  end    

  #
  def search_rubygems(match, options={})
    ::Gem.search(match)
  end

end

#$LOAD_PROC << OriginalLoader.new

