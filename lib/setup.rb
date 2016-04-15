require 'FileUtils'
require 'erb'
require './lib/module.rb'
class Setup
  include BaseFile

  def initialize(file_path)
    @file_path = file_path
  end

  def new_project_skeleton
    if Dir.exists?(base_file)
      raise ArgumentError.new("directory already exists")
    else
      FileUtils.mkdir_p(base_file)
    end

    create_folders
    create_sub_folders
    create_files
    setup_default_layout
  end

  def create_folders
    ["output", "source"].each do |element|
      FileUtils.mkdir_p(File.join(base_file, "/#{element}"))
    end
  end

  def create_sub_folders
    sub_folders = ["source/css",
      "source/pages",
      "source/posts",
      "source/layouts",
      "output/tags"]
      sub_folders.each do |element|
        FileUtils.mkdir_p(File.join(base_file, "/#{element}"))
      end
    end

    def create_files
      date = Time.new.strftime("%Y-%m-%d")
      files = ["css/main.css",
        "index.md",
        "pages/about.md",
        "posts/#{date}-welcome-to-hyde.md",
        "layouts/default.html.erb"]
        files.each do |file|
          FileUtils.touch (File.join(base_file,"/source/#{file}"))
        end
      end

      def setup_default_layout
        format = File.read("./lib/default_template.html.erb")
        File.write(File.join(base_file, "/source/layouts/default.html.erb"), format)
      end
    end
