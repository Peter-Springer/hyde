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
    else
      setup.new_project_skeleton
      copy_source
      flag_markdowns
      convert_md_to_html
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

end
