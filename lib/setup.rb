require 'FileUtils'
require 'erb'
class Setup

  def initialize(file_path)
    @file_path = file_path
  end

  def new_project_skeleton
    if Dir.exists?(File.join(Dir.pwd, "#{@file_path}"))
      raise ArgumentError.new("directory already exists")
    else
      FileUtils.mkdir_p(File.join(Dir.pwd, "#{@file_path}"))
    end

    create_folders
    create_sub_folders
    create_files
    setup_default_layout("Juicy Post", "Your content here")
  end

  def create_folders
    ["output", "source"].each do |element|
      FileUtils.mkdir_p(File.join(Dir.pwd, "#{@file_path}/#{element}"))
    end
  end

  def create_sub_folders
    ["css", "pages", "posts", "layouts"].each do |element|
      FileUtils.mkdir_p(File.join(Dir.pwd, "#{@file_path}/source/#{element}"))
    end
  end

  def create_files
    date = Time.new.strftime("%Y-%m-%d")
    FileUtils.touch (File.join(Dir.pwd, "#{@file_path}/source/css/main.css"))
    FileUtils.touch (File.join(Dir.pwd, "#{@file_path}/source/index.md"))
    FileUtils.touch (File.join(Dir.pwd, "#{@file_path}/source/pages/about.md"))
    FileUtils.touch (File.join(Dir.pwd, "#{@file_path}/source/posts/#{date}-welcome-to-hyde.md"))
    FileUtils.touch (File.join(Dir.pwd, "#{@file_path}/source/layouts/default.html.erb"))
  end

  def setup_default_layout(title, content)
    default_format = "./lib/default_template.html.erb"
    default_file = File.join(Dir.pwd, "#{@file_path}/source/layouts/default.html.erb")
    read_default = File.read(default_format)
    new_text = ERB.new(read_default).result(binding)
    File.write(default_file, new_text)
  end

end
