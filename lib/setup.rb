require 'FileUtils'
class Setup

  def initialize(file_path)
    @file_path = file_path
  end

  def new_project_skeleton
    if Dir.exists?(File.join(Dir.home, "#{@file_path}"))
      raise ArgumentError.new("directory already exists")
    else
      Dir.mkdir(File.join(Dir.home, "#{@file_path}"))
    end

    create_folders
    create_sub_folders
    create_files
  end

  def create_folders
    ["output", "source"].each do |element|
      Dir.mkdir(File.join(Dir.home, "#{@file_path}/#{element}"))
    end
  end

  def create_sub_folders
    ["css", "pages", "posts"].each do |element|
      Dir.mkdir(File.join(Dir.home, "#{@file_path}/source/#{element}"))
    end
  end

  def create_files
    date = Time.new.strftime("%Y-%m-%d")
    FileUtils.touch (File.join(Dir.home, "#{@file_path}/source/css/main.css"))
    FileUtils.touch (File.join(Dir.home, "#{@file_path}/source/index.md"))
    FileUtils.touch (File.join(Dir.home, "#{@file_path}/source/pages/about.md"))
    FileUtils.touch (File.join(Dir.home, "#{@file_path}/source/posts/#{date}-welcome-to-hyde.markdown"))
  end
end
