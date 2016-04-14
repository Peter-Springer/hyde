require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/build.rb'
require './lib/setup.rb'
require './lib/post.rb'

class PostTest < Minitest::Test

  def test_format_title_returns_title_with_no_spaces
    b = Build.new("/test/newproject")
    post = Post.new("/test/newproject", "Lets Go")
    build_project_scaffold(b)
    post.format_title

    assert_equal "Lets-Go", post.format_title

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_basic_content
    b = Build.new("/test/newproject")
    post = Post.new("/test/newproject", "Lets Go")
    build_project_scaffold(b)
    post.create_new_file
    post.basic_content
    b.build

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end


    def build_project_scaffold(b)
      b.setup.new_project_skeleton
      b.copy_source
    end


end
