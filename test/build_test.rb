require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/build.rb'
require './lib/setup.rb'
require './lib/post.rb'
require 'FileUtils'

class BuildTest < Minitest::Test

  def test_copy_source_creates_subfolders
    b = Build.new("/test/newproject")
    b.setup.new_project_skeleton
    b.copy_source

    assert Dir.exist?(File.join(Dir.pwd, "/test/newproject/output/css"))
    assert Dir.exist?(File.join(Dir.pwd, "/test/newproject/output/pages"))
    assert Dir.exist?(File.join(Dir.pwd, "/test/newproject/output/posts"))

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_copy_source_creates_subfolders
    b = Build.new("/test/newproject")
    b.setup.new_project_skeleton
    date = Time.new.strftime("%Y-%m-%d")
    b.copy_source

    assert File.exist?(File.join(Dir.pwd, "/test/newproject/output/index.md"))
    assert File.exist?(File.join(Dir.pwd, "/test/newproject/output/css/main.css"))
    assert File.exist?(File.join(Dir.pwd, "/test/newproject/output/pages/about.md"))
    assert File.exist?(File.join(Dir.pwd, "/test/newproject/output/posts/#{date}-welcome-to-hyde.md"))

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_flag_mark_downs_returns_markdown_files
    b = Build.new("/test/newproject")
    b.setup.new_project_skeleton
    b.copy_source
    b.flag_markdowns

    assert_equal 3, b.flag_markdowns.length

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_convert_md_to_html_works
    b = Build.new("/test/newproject")
    build_project_scaffold(b)
    date = Time.new.strftime("%Y-%m-%d")

    new_html = "<h1 id=\"some-markdown\">Some Markdown</h1>\n\n<ul>\n  <li>a list</li>\n  <li>another item</li>\n</ul>\n"
    assert_equal new_html, File.read(File.join(Dir.pwd, "/test/newproject/output/index.html"))

    assert File.exist?(File.join(Dir.pwd, "/test/newproject/output/index.html"))
    assert File.exist?(File.join(Dir.pwd, "/test/newproject/output/pages/about.html"))
    assert File.exist?(File.join(Dir.pwd, "/test/newproject/output/posts/#{date}-welcome-to-hyde.html"))

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_injection_works
    b = Build.new("/test/newproject")
    build_project_scaffold(b)
    b.build

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_extract_tags_returns_empty_array_on_empty_post
    b = Build.new("/test/newproject")
    build_project_scaffold(b)
    b.build
    b.extract_tags

    assert_equal ["keys:"], b.tag_hash.keys
    assert_equal [[]], b.tag_hash.values

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_extract_tags_returns_tags_in_single_array
    b = Build.new("/test/newproject")
    build_project_scaffold(b)
    create_practice_test_post
    b.copy_source
    b.flag_markdowns
    b.extract_tags

    assert_equal 1, b.tag_hash.values.length
    assert_equal 4, b.tag_hash.values[0].length

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_clean_up_tags_makes_snake_and_down_case
    b = Build.new("/test/newproject")
    build_project_scaffold(b)
    create_practice_test_post
    b.copy_source
    b.flag_markdowns
    b.extract_tags
    result = b.clean_up_tag_names

    assert_equal 4, result[0].length
    assert_equal "national_league", result[0][2]

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end

  def test_tag_directory_gets_built
    b = Build.new("/test/newproject")
    build_project_scaffold(b)
    create_practice_test_post
    b.build

    assert Dir.exist?(File.join(Dir.pwd, "/test/newproject/output/tags"))

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end


  def build_project_scaffold(b)
    b.setup.new_project_skeleton
    b.copy_source
    File.write(File.join(Dir.pwd, "/test/newproject/output/index.md"), "# Some Markdown\n\n* a list\n* another item")
    b.flag_markdowns
    b.convert_md_to_html
  end

  def create_practice_test_post
    post = Post.new("/test/newproject", "practice_posts_for_tests")
    FileUtils.copy_file(File.join(Dir.pwd, "/lib/practice_post_for_tests.md"), File.join(Dir.pwd, "/test/newproject/source/posts/practice_post_for_tests.md"))
  end
end
