require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/setup.rb'

class SetupTest < Minitest::Test

  def test_new_project_skeleton_creates_project_file
    dir = Setup.new
    result = dir.new_project_skeleton("/Users/charleskaminer/turing/1module/hyde/newproject")
    assert result

    FileUtils.remove_dir("/Users/charleskaminer/turing/1module/hyde/newproject")
  end

  def test_new_project_skeleton_returns_argument_error_if_file_exits
    dir = Setup.new
    dir.new_project_skeleton("/Users/charleskaminer/turing/1module/hyde/newproject")

    assert_raises ArgumentError do
      dir.new_project_skeleton("/Users/charleskaminer/turing/1module/hyde/newproject")
    end

    FileUtils.remove_dir("/Users/charleskaminer/turing/1module/hyde/newproject")
  end

end
