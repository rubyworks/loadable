require 'rbconfig/core_ext/rubygems' if defined?(::Gem)

module Free

  # Find library files (e.g. plugins), searching through standard $LOAD_PATH,
  # as well as RubyGems and Roll packages if these load systems are being used.
  #
  #   RbConfig.library_search('rdoc/discover.rb')
  #
  def self.search(match, options={})
    list = []
    search_locators.each do |locator|
      list.concat(locator.call(match,options) || [])
    end
    list.uniq
  end

  # List of search procedures, in order of priority.
  def self.search_locators
    @search_locators ||= []
  end

  # Search Roll system for current or latest libraries.
  #
  # This only searches actived libraries, or the most recent version
  # of any given library.
  #
  def self.search_rbledger(glob, options={})
    return unless defined?(::Roll)
    ::Library.find_files(glob, options)
  end

  # Search standard $LOAD_PATH.
  #
  # NOTE: in older versions of RubyGems, activated gem versions are in here too.
  def self.search_loadpath(match, options={})
    matches = []
    $LOAD_PATH.uniq.each do |path|
      path = File.expand_path(path)
      list = Dir.glob(File.join(path, match))
      list = list.map{ |d| d.chomp('/') }
      matches.concat(list)
    end
    matches
  end

  # Search gems for files.
  #
  def self.search_rubygems(glob, options={})
    return unless defined?(::Gem)
    ::Gem.search(glob)
  end

  # TODO: proper order?
  search_locators << method(:search_rbledger) if defined?(::Roll)
  search_locators << method(:search_loadpath) 
  search_locators << method(:search_rubygems) if defined?(::Gem)

  ## This is the same as +up+ but searches within the standard +plugins/+
  ## directory. Using the standard +plugins+ directory makes it easier for
  ## developers to locate plugins, and helps prevent file name clashes with
  ## regular library scripts. For example, if your project is called 'milkdud'
  ## and it supports plugin scripts, they would reside in the a project's 
  ## <code>lib/plugins/milkdud/</code> directory.
  ##
  ##   Look.up_plugins('syckle/*')
  ##
  #def self.up_plugins(match, options={})
  #  up(File.join('plugins',match), options)
  #end

end
