require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/setup.rb'

class SetupTest < Minitest::Test

  def test_new_project_skeleton_creates_project_file
    assert_equal  ~/turing/1module/hyde/newproject/version1, Setup.new.new_project_skeleton(~/turing/1module/hyde/newproject/version1)
  end

  def test_setup_exists
    assert Setup.new
  end


end
