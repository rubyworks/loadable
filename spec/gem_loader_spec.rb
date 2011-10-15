require 'helper'
require 'loadable'

# TODO: techincally these tests need to be isolated in separate processes
# to truly work right, but we won't overly fret about it presently b/c
# MiniTest randomizes execution order, so they will get fully tested
# over the course a handful of runs.

describe "GemLoader" do

  # setup alternate loadpath
  dir = File.expand_path(File.dirname(__FILE__) + '/fixture')

  before do
    $LOAD_PATH.unshift(dir)
  end

  after do
    $LOAD_PATH.delete(dir)
  end

  it "should load local library when neither `:gem` or `:from` option is supplied" do
    require 'ansi'
    assert $NO_ANSI, "Local `ansi.rb' library not loaded."
  end

  it "should load the gem when `:from` option is supplied" do
    require 'ansi', :gem=>'ansi'
    assert ANSI, "Ruby `ansi.rb' library not loaded."
  end

  it "should load from the gem when the `:gem` option is supplied" do
    require 'ansi', :from=>'ansi'
    assert ANSI, "Ruby `ansi.rb' library not loaded."
  end

end

