require 'wedge/ruby'

context "Alternate LoadPath" do

  dir = File.expand_path(File.dirname(__FILE__) + '/fixture')

  setup do
    $LOAD_PATH.unshift(dir)
  end

  teardown do
    $LOAD_PATH.delete(dir)
  end

end

feature "Loading Standard Ruby Libraries" do

  use "Alternate LoadPath"

  scenario "without the ruby wedge" do
    require 'abbrev'
    $NO_RUBY_WEDGE.assert == true
  end

  scenario "with the ruby wedge" do
    require 'ruby/abbrev'
    Abbrev
  end

end

