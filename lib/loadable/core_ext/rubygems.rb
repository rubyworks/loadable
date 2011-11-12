module Gem

  # Search RubyGems for matching paths in current gem versions.
  def self.search(match, options={})
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

  class Specification
    # Return a list of actives specs, or latest version if not active.
    def self.current_specs
      named = Hash.new{|h,k| h[k] = [] }
      each{ |spec| named[spec.name] << spec }
      list = []
      named.each do |name, vers|
        if spec = vers.find{ |s| s.activated? }
          list << spec
        else
          spec = vers.max{ |a,b| a.version <=> b.version }
          list << spec
        end
      end
      return list
    end

    # Return full path of requireable file path given relative path.
    def find_requirable_file(file)
      root = full_gem_path

      require_paths.each do |lib|
        base = "#{root}/#{lib}/#{file}"
        Gem.suffixes.each do |suf|
          path = "#{base}#{suf}"
          return path if File.file? path
        end
      end

      return nil
    end
  end

=begin
  class GemPathSearcher
    # Return a list of matching files among active or latest gems.
    def current_files(glob)
      matches  = {}
      gemspecs = init_gemspecs

      # loaded specs
      gemspecs.each do |spec|
        next unless spec.loaded?
        next if matches.key?(spec.name)
        files = matching_files(spec, glob)
        matches[spec.name] = files
      end

      # latest specs
      gemspecs.each do |spec|
        next if matches.key?(spec.name)
        files = matching_files(spec, glob)
        matches[spec.name] = files
      end

      matches.values.flatten.uniq
    end
  end
=end

end
