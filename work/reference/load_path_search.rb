class << $LOAD_PATH

  # Search standard $LOAD_PATH.
  #
  #   $LOAD_PATH.search('rdoc/discover.rb')
  #
  # NOTE: in older versions of RubyGems, activated gem versions are in here too.
  #
  def search(match, options={})
    matches = []
    self.uniq.each do |path|
      path = File.expand_path(path)
      list = Dir.glob(File.join(path, match))
      list = list.map{ |d| d.chomp('/') }
      matches.concat(list)
    end
    matches
  end

end
