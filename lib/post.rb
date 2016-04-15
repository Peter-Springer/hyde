require './lib/build.rb'
require './lib/module.rb'

class Post
  include BaseFile

  def initialize(file_path, title)
    @file_path = file_path
    @title = title
  end

  def new_post
    if Dir.exist?(base_file)
      format_title
      create_new_file
      basic_content
    else
      Build.new(@file_path).setup.new_project_skeleton
      format_title
      create_new_file
      basic_content
    end
  end

  def format_title
    @title.gsub(" ", "-")
  end

  def create_new_file
    date = Time.new.strftime("%Y-%m-%d")
    FileUtils.touch (File.join(base_file, "/source/posts/#{date}-#{format_title}.md"))
  end
    
  def basic_content
    content = "Your content here"
    date = Time.new.strftime("%Y-%m-%d")
    message = "---\ntags:\n---\n# #{@title}\n\n#{content}\n\n# Tag Links#{write_links}"
    File.write(File.join(base_file, "/source/posts/#{date}-#{format_title}.md"), message)
  end

end
