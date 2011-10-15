module Loadable

  # Stores active loaders.
  $LOADERS = []

  # Require/load script.
  #
  # @param [String] fname
  #   The script to require/load.
  #
  def self.call(fname, options={})
    success = nil
    $LOADERS.each do |wedge| 
      success = wedge.call(fname, options)
      break unless success.nil?
    end
    return success
  end

  # Iterate over all requirable files.
  #
  #   LoadSystem.each{ |file| p file }
  #
  # Note that esoteric load wedges may return a symbolic path rather than
  # an actual file path.
  #
  def self.each(options={}, &block)
    $LOADERS.each do |wedge| 
      wedge.each(options, &block)
    end
  end

  # Search wedges for all matching paths.
  #
  #   LoadSystem.search('detroit-*.rb')
  #
  # Note that "esoteric" wedges might return a symbolic identifier rather
  # than an actual file path.
  #
  # TODO: Handle default ruby extensions in search.
  def self.search(glob, options={}, &criteria)
    matches = []
    $LOADERS.each do |wedge| 
      wedge.each do |path|
        next unless criteria.call(path) if criteria
        matches << path if File.fnmatch?(glob, path.to_s)  # TODO: add `options[:flags].to_i` ?
      end
    end
    matches
  end

  # Vendor location.
  #
  def self.vendor(*directory)
    $LOADERS.unshift(VendorLoader.new(*directory))
  end

  # Add a loader to the $LOADERS global variable.
  #
  def self.register(loader)
    $LOADERS.unshift(loader)
  end

end
