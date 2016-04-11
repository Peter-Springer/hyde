require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/setup.rb'

class SetupTest < Minitest::Test

  def test_new_project_skeleton_creates_project_file
<<<<<<< HEAD
    dir = Setup.new
    result = dir.new_project_skeleton() 
=======

>>>>>>> 4f11b67cd26e2b0d14cd5253f47cff19ea9daa4e
  end

  def test_setup_exists
    assert Setup.new
  end


end
