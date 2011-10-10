require 'load/gem/specification' if defined?(::Gem)

# TODO: Convert this into an aspect of load wedges.

module Load

  # Find library files (e.g. plugins), searching through standard $LOAD_PATH,
  # as well as RubyGems and Roller packages if they are being used.
  #
  #   Wedge.locate('rdoc/discover.rb')
  #
  def self.locate(match, options={})
    list = []
    list.concat locate_roll(match, options)
    list.concat locate_loadpath(match, options)
    list.concat locate_rubygems(match, options)
    list.uniq
  end

  # Search standard $LOAD_PATH.
  #
  # NOTE: in older versions of RubyGems, activated gem versions are in here too.
  def self.locate_loadpath(match, options={})
    matches = []
    $LOAD_PATH.uniq.each do |path|
      path = File.expand_path(path)
      list = Dir.glob(File.join(path, match))
      list = list.map{ |d| d.chomp('/') }
      matches.concat(list)
    end
    matches
  end

  # Search RubyGems for matching paths in current gem versions.
  #
  def self.locate_rubygems(match, options={})
    return unless defined?(::Gem)
    matches = []
    Gem::Specification.current_specs.each do |spec|
      glob = File.join(spec.lib_dirs_glob, match)
      list = Dir[glob] #.map{ |f| f.untaint }
      list = list.map{ |d| d.chomp('/') }
      matches.concat(list)
    end
    matches
  end

  # Search Roll for current or latest libraries.
  #
  def self.locate_roll(match, options={})
    return unless defined?(::Roll) #Library
    matches = []
    ::Library.ledger.each do |name, lib|
      lib = lib.sort.first if Array===lib
      lib.loadpath.each do |path|
        find = File.join(lib.location, path, match)
        list = Dir.glob(find)
        list = list.map{ |d| d.chomp('/') }
        matches.concat(list)
      end
    end
    matches
  end

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
