module Kernel
  alias_method :require_without_wedge, :require
  alias_method :load_without_wedge, :load
end

  # Loaders are used to safely inject new import logic into Ruby's
  # require/load system.
  #
  # Active load wedges are stored in `$LOAD_WEDGE` global variable.
  class Loader

    #
    module Helper

      # TODO: Some extensions are platform specific --only add the ones needed
      # for the current platform.
      SUFFIXES = ['.rb', '.rbw', '.so', '.bundle', '.dll', '.sl', '.jar'] #, '']

      alias_method :require, :require_without_wedge
      alias_method :load,    :load_without_wedge

      # Good idea?
      #def self.extended(base)
      #  LoadWedge.register base
      #end

      #
      def call(fname, options={})
        if options[:load]
          load(fname, options[:wrap])
        else
          require(fname)
        end
      end

      # A load wedge should provide a means for locating the file
      # that the `#call` method would load.
      #
      # If a load wedge is "esoteric", in that it doesn't actually load
      # a file, then it's `#find` method should return a suitable identifier.
      #
      def find(fname, options={})
      end

      # You can override this method in your wedge and use #find
      # for other extension types.
      def suffixes
        SUFFIXES
      end

      # Name of wedge.
      def name
        self.class.name
      end

    private

      # Given a base-path, and a path relative to it determine if a matching
      # file exists. Unless +:load+ option is +true+, this will check for each
      # viable Ruby suffix. If a match is found the full path to the file
      # is returned, otherwise +nil+.
      #
      def lookup(base_path, relative_path, options={})
        if options[:load] or suffixes.include?(File.extname(relative_path))
          abspath = File.join(base_path, relative_path)
          File.exist?(abspath) ? abspath : nil
        else
          suffixes.each do |ext|
            abspath = File.join(base_path, relative_path + ext)
            return abspath if File.exist?(abspath)
          end
        end
        nil
      end

      # Raise LoadError with an error message patterned after Ruby's standard 
      # error message when a script can't be required or loaded.
      #
      def raise_load_error(fname)
        raise LoadError, "no such file to load -- #{fname}"
      end

    end

    #
    include Helper

  end


