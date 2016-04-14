require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/build.rb'
require './lib/setup.rb'

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

  def test_extract_tags_returns_empty_hash_on_empty_post
    b = Build.new("/test/newproject")
    build_project_scaffold(b)
    b.build
    #b.extract_tags

    assert_equal Hash, b.tag_hash.class

    FileUtils.remove_dir(File.join(Dir.pwd, "/test/newproject"))
  end


  def build_project_scaffold(b)
    b.setup.new_project_skeleton
    b.copy_source
    File.write(File.join(Dir.pwd, "/test/newproject/output/index.md"), "# Some Markdown\n\n* a list\n* another item")
    b.flag_markdowns
    b.convert_md_to_html
  end

end
