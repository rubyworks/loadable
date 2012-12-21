require 'helper'
require 'loadable'

describe "RubyLoader" do

  # setup alternate loadpath
  dir = File.expand_path(File.dirname(__FILE__) + '/fixture')

  before do
    $LOAD_PATH.unshift(dir)
  end

  after do
    $LOAD_PATH.delete(dir)
  end

  it "should load local library without the ruby prefix" do
    require 'abbrev'
    assert $NO_ABBREV, "Local `abbrev.rb' library not loaded."
  end

  it "should load the standard ruby library with the `:from` ruby option" do
    require 'abbrev', :from=>'ruby'
    assert Abbrev, "Ruby `abbrev.rb' library not loaded."
  end

  it "should iterate over standard ruby libs" do
    loader = Loadable::RubyLoader.new

    list = []
    loader.each{ |f| list << f }

    assert list.include?('abbrev.rb')
    assert list.include?('ostruct.rb')
  end

end

