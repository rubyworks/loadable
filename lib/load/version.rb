module Load
  def self.metadata
    @metadata ||= (
      require 'yaml'
      YAML.load_file(File.dirname(__FILE__) + '/load.yml')
    )
  end

  def self.method_missing(name)
    metadata[name.to_s.downcase] || super(name)
  end
end
