require 'FileUtils'
require 'kramdown'
require 'Find'
require './lib/setup.rb'

class Build

  attr_reader :setup

  def initialize(file_path)
    @setup = Setup.new(file_path)
    @file_path = file_path
  end

  def build
    if Dir.exist?(File.join(Dir.pwd, @file_path))
      copy_source
      flag_markdowns
      convert_md_to_html
      inject_layout
    else
      setup.new_project_skeleton
      copy_source
      flag_markdowns
      convert_md_to_html
      inject_layout
    end
  end

  def copy_source
    FileUtils.cp_r(File.join(Dir.pwd, "#{@file_path}/source/."), File.join(Dir.pwd, "#{@file_path}/output"))
  end

  def flag_markdowns
    markdown_files = []
    Find.find(File.join(Dir.pwd, "#{@file_path}/output")) do |path|
      markdown_files << path if path =~ /.*\.md$/
    end
    markdown_files
  end

  def convert_md_to_html
    flag_markdowns.each do |path|
      start_new_path = path.gsub(Dir.pwd, "")
      markdown = File.read(path)
      html = Kramdown::Document.new(markdown).to_html
      File.write(path.gsub(".md", ".html"), html)
      File.delete(path)
    end
  end

  def flag_html
    html_files = []
    Find.find(File.join(Dir.pwd, "#{@file_path}/output")) do |path|
      html_files << path if path =~ /.*\.html$/
    end
    html_files
  end

  def inject_layout
    content = File.read(File.join(Dir.pwd,"/test/newproject/output/posts/2016-04-13-pleasework.html"))
    erb = ERB.new(File.read(File.join(Dir.pwd,"/test/newproject/source/layouts/default.html.erb"))).result(binding)
    File.write(File.join(Dir.pwd,"/test/newproject/output/posts/2016-04-13-pleasework.html"), erb)
  end

  # def inject_layout_into_output_posts
  #   default_format = "./lib/default_template.html.erb"
  #   read_default = File.read(default_format)
  #   flag_html(title, content).each do |path|
  #     new_text = ERB.new(read_default).result(binding)
  #     File.write(path, new_text)
  #   end
  # end


end
