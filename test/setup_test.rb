require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/setup.rb'

class SetupTest < Minitest::Test

  def test_new_project_skeleton_creates_project_file
    dir = Setup.new
    result = dir.new_project_skeleton() 
  end

  def test_setup_exists
    assert Setup.new
  end


end
