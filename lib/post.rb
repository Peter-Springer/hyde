require './lib/build.rb'

class Post

  def initialize(file_path, title)
    @file_path = file_path
    @title = title
  end

  def new_post
    if Dir.exist?(File.join(Dir.pwd, @file_path))
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
    FileUtils.touch (File.join(Dir.pwd, "#{@file_path}/source/posts/#{date}-#{format_title}.md"))
  end

  def basic_content
    content = "Your content here"
    date = Time.new.strftime("%Y-%m-%d")
    message = "# #{@title}\n\n#{content}"
    File.write(File.join(Dir.pwd, "#{@file_path}/source/posts/#{date}-#{format_title}.md"), message)
  end

end
