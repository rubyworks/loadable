#module Kernel
#  alias_method :require_without_wedge, :require
#  alias_method :load_without_wedge, :load
#end

module LoadSystem

  # Stores active loaders.
  $LOADERS = []

  # Require script.
  #
  # @param [String] fname
  #   The script to require.
  #
  def self.require(fname, options={})
    options[:load] = false
    success = nil
    $LOAD_WEDGE.each do |wedge| 
      success = wedge.call(fname, options)
      next if success.nil?
    end
    success
  end

  # Load script.
  #
  # @param [String] fname
  #   The script to load.
  #
  def self.load(fname, options={})
    options = Hash===options ? options : {:wrap=>options}
    options[:load] = true
    success = nil
    $LOAD_WEDGE.each do |wedge| 
      success = wedge.call(fname, options)
      next if success.nil?
    end
    success
  end

  # Search load wedges for a matching path. Returns the first match found.
  #
  #   LoadSystem.find('detroit-*.rb')
  #
  # Note that esoteric wedges might return a symbolic identifier rather than
  # an actual file path. Use #find_file to ensure the return value is
  # an existant local file.
  #
  def self.find(fname, options={}) #:yield:
    if block_given?
      $LOAD_WEDGE.each do |wedge| 
        uri = wedge.find(fname, options)
        return uri if uri && yield(uri)
      end
    else
      $LOAD_WEDGE.each do |wedge| 
        uri = wedge.find(fname, options)
        return uri if uri
      end
    end
  end

  # Search wedges for all matching paths.
  #
  #   LoadSystem.search('detroit-*.rb')
  #
  # Note that esoteric wedges might return a symbolic identifier rather than
  # an actual file path.
  # 
  def self.search(glob, options={})
    matches = []
    $LOAD_WEDGE.each do |wedge| 
      matches.concat(wedge.search(glob, options))
    end
    matches
  end

  # Search wedges for a matching path. Returns the first match found.
  # Unlike #find, this will ignore any non-existant file returned by
  # a wedge's `#find` method.
  #
  #   LoadSystem.find_file('detroit-*.rb')
  #
  def self.find_file(fname, options={})
    $LOAD_WEDGE.each do |wedge| 
      file = wedge.find(fname, options)
      return file if file && File.exist?(file) #String===file
    end
  end

end

module Kernel
  #
  def require(fname, options={})
    success = LoadSystem.require(fname, options)
    if success.nil?
      success = require_without_wedge(fname)
    end
    success
  end

  #
  def load(fname, options={})
    success = LoadSystem.load(fname, options)
    if success.nil?
      success = load_without_wedge(fname)
    end
    success
  end
end

