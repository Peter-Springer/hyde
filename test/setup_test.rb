require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/setup.rb'

class SetupTest < Minitest::Test

  def test_new_project_skeleton_creates_project_file
    dir = Setup.new("/turing/1module/hyde/newproject")
    result = dir.new_project_skeleton
    assert result

    FileUtils.remove_dir("/Users/charleskaminer/turing/1module/hyde/newproject")
  end

  def test_new_project_skeleton_returns_argument_error_if_file_exits
    dir = Setup.new("/turing/1module/hyde/newproject")
    dir.new_project_skeleton

    assert_raises ArgumentError do
      dir.new_project_skeleton
    end

    FileUtils.remove_dir("/Users/charleskaminer/turing/1module/hyde/newproject")
  end

  def test_create_folders_creates_output_and_source_directories
    dir = Setup.new("/turing/1module/hyde/newproject")
    dir.new_project_skeleton
    output = "/turing/1module/hyde/newproject/output"
    source = "/turing/1module/hyde/newproject/source"

    assert output
    assert source

    FileUtils.remove_dir("/Users/charleskaminer/turing/1module/hyde/newproject")
  end

  def test_create_sub_folders_creates_source_sub_directories
    dir = Setup.new("/turing/1module/hyde/newproject")
    dir.new_project_skeleton
    css   = "/Users/charleskaminer/turing/1module/hyde/newproject/source/css"
    pages = "/Users/charleskaminer/turing/1module/hyde/newproject/source/pages"
    posts = "/Users/charleskaminer/turing/1module/hyde/newproject/source/posts"

    assert css
    assert pages
    assert posts

    FileUtils.remove_dir("/Users/charleskaminer/turing/1module/hyde/newproject")
  end

  def test_create_file
    dir = Setup.new("/turing/1module/hyde/newproject")
    dir.new_project_skeleton
    date = Time.new.strftime("%Y-%m-%d")
    main_css = "/Users/charleskaminer/turing/1module/hyde/newproject/source/css/main.css"
    index_md = "/Users/charleskaminer/turing/1module/hyde/newproject/source/index.md"
    about_md = "/Users/charleskaminer/turing/1module/hyde/newproject/source/pages/about.md"
    time_md = "/Users/charleskaminer/turing/1module/hyde/newproject/source/posts/#{date}-welcome-to-hyde.md"

    assert main_css
    assert index_md
    assert about_md
    assert time_md

    FileUtils.remove_dir("/Users/charleskaminer/turing/1module/hyde/newproject")
  end

end
