require 'helper'
require 'loadable'

describe "VendorLoader" do

  dir = File.dirname(__FILE__) + '/fixture'

  it "should be able to vendor a directory directly" do
    loader = Loadable::VendorLoader.new(dir, :direct=>true)
    list = []
    loader.each{ |f| list << f }
    list.must_include('abbrev.rb')
    list.must_include('ansi.rb')
  end

  it "should be able to vendor subprojects" do
    loader = Loadable::VendorLoader.new(dir, '*')
    list = []
    loader.each{ |f| list << f }
    list.must_include('subpro.rb')
  end

  it "should vendor using the Loadable class method" do
    Loadable.vendor(dir, '*')
    require 'subpro'
    assert $SUBPRO, "Vendored project not loaded."
  end

end

