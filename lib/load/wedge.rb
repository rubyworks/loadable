module Kernel
  alias_method :require_without_wedge, :require
  alias_method :load_without_wedge, :load
end

module Load

  # Load Wedges are used to safely inject new import logic into Ruby's
  # require/load system.
  #
  class Wedge

    # Stores registered wedges.
    REGISTRY = []

    # Class method access to REGISTRY constant.
    def self.registry
      REGISTRY
    end

    # Register a wedge, adding it to REGISTRY.
    def self.register(wedge)
      registry << wedge
    end

    # Require script.
    #
    # @param [String] fname
    #   The script to require.
    #
    def self.require(fname, options={})
      options[:load] = false
      success = nil
      registry.each do |wedge| 
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
      registry.each do |wedge| 
        success = wedge.call(fname, options)
        next if success.nil?
      end
      success
    end

=begin
    # Search wedges for matching paths.
    #
    #   Wedge.search('detroit-*.rb')
    #
    # TODO: Ruby 1.9 use #try instead of respond_to?
    def self.search(fname, options={})
      matches = []
      registry.each do |wedge| 
        if wedge.respond_to?(:search)
          list = wedge.search(fname, options)
          matches.concat(list) if list
        end
      end
      matches
    end
=end

    #
    module Helper

      # TODO: Some extensions are platform specific --only add the ones needed
      # for the current platform.
      SUFFIXES = ['.rb', '.rbw', '.so', '.bundle', '.dll', '.sl', '.jar'] #, '']

      alias_method :require, :require_without_wedge
      alias_method :load, :load_without_wedge

      # Good idea?
      def self.extended(base)
        Wedge.register base
      end

      #
      def call(fname, options={})
        if options[:load]
          load(fname, options[:wrap])
        else
          require(fname)
        end
      end

      # Given a +loadpath+, a file's relative path, +relname+, and 
      # options hash, determine a matching file exists. Unless +:load+
      # option is +true+, this will check for each viable Ruby suffix.
      # If a match is found the full path to the file is returned,
      # otherwise +nil+.
      def find(loadpath, relname, options={})
        if options[:load] or suffixes.include?(File.extname(relname))
          abspath = File.join(loadpath, relname)
          File.exist?(abspath) ? abspath : nil
        else
          suffixes.each do |ext|
            abspath = File.join(loadpath, relname + ext)
            return abspath if File.exist?(abspath)
          end
        end
        nil
      end

      # You can override this method in in your wedge and use #find
      # for other extension types.
      def suffixes
        SUFFIXES
      end

      #
      def raise_load_error(fname)
        raise LoadError, "no such file to load -- #{fname}"
      end

    end

    #
    include Helper

    # Create a new Load Wedge and automatically register it.
    # The +name+ argument is used to identify the Wedge when
    # an error occurs. The block is evaluated in the object's 
    # singleton class.
    def initialize(name, &block)
      @name = name
      (class << self; self; end).class_eval(&block)
      Wedge.register(self)
    end

  end

end

module Kernel
  #
  def require(fname, options={})
    success = Load::Wedge.require(fname, options)
    if success.nil?
      success = require_without_wedge(fname)
    end
    success
  end

  #
  def load(fname, options={})
    success = Load::Wedge.load(fname, options)
    if success.nil?
      success = load_without_wedge(fname)
    end
    success
  end
end

