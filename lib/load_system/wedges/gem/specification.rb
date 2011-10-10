module Gem
  class Specification

    #
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

  end
end
