require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/setup.rb'

class SetupTest < Minitest::Test

  def test_new_project_skeleton_creates_project_file
    dir = Setup.new("/test/newproject")
    dir.new_project_skeleton
    assert Dir.exist?(File.join(Dir.pwd, "/test/newproject"))

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_new_project_skeleton_returns_argument_error_if_file_exits
    dir = Setup.new("/test/newproject")
    dir.new_project_skeleton

    assert_raises ArgumentError do
      dir.new_project_skeleton
    end

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_create_folders_creates_output_and_source_directories
    dir = Setup.new("/test/newproject")
    dir.new_project_skeleton
    output = File.join(Dir.pwd, "/test/newproject/output")
    source = File.join(Dir.pwd, "/test/newproject/source")

    assert Dir.exist?(output)
    assert Dir.exist?(source)

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_create_sub_folders_creates_source_sub_directories
    dir = Setup.new("/test/newproject")
    dir.new_project_skeleton
    css   = File.join(Dir.pwd, "/test/newproject/source/css")
    pages = File.join(Dir.pwd, "/test/newproject/source/pages")
    posts = File.join(Dir.pwd, "/test/newproject/source/posts")

    assert Dir.exist?(css)
    assert Dir.exist?(pages)
    assert Dir.exist?(posts)

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_create_file
    dir = Setup.new("/test/newproject")
    dir.new_project_skeleton
    date = Time.new.strftime("%Y-%m-%d")
    main_css = File.join(Dir.pwd, "/test/newproject/source/css/main.css")
    index_md = File.join(Dir.pwd, "/test/newproject/source/index.md")
    about_md = File.join(Dir.pwd, "/test/newproject/source/pages/about.md")
    time_md = File.join(Dir.pwd, "/test/newproject/source/posts/#{date}-welcome-to-hyde.md")

    assert File.exist?(main_css)
    assert File.exist?(index_md)
    assert File.exist?(about_md)
    assert File.exist?(time_md)

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_default_layout
    dir = Setup.new("/test/newproject")
    dir.new_project_skeleton

    assert Dir.exist?(File.join(Dir.pwd, "/test/newproject/source/layouts"))
    assert File.exist?(File.join(Dir.pwd, "/test/newproject/source/layouts/default.html.erb"))

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end
end
