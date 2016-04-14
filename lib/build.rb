require 'FileUtils'
require 'kramdown'
require 'Find'
require './lib/setup.rb'
require './lib/module.rb'

class Build
  include BaseFile
  attr_reader :setup, :tag_hash

  def initialize(file_path)
    @setup = Setup.new(file_path)
    @file_path = file_path
    @tag_hash = {}
  end

  def build
    if Dir.exist?(base_file)
      copy_source
      extract_tags
      flag_markdowns
      convert_md_to_html
      inject_layout_to_all
    else
      setup.new_project_skeleton
      copy_source
      extract_tags
      flag_markdowns
      convert_md_to_html
      inject_layout_to_all
    end
  end

  def copy_source
    FileUtils.cp_r(File.join(base_file, "/source/."), File.join(base_file, "/output"))
  end

  def flag_markdowns
    markdown_files = []
    Find.find(File.join(base_file, "/output")) do |path|
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
    Find.find(File.join(base_file, "/output")) do |path|
      html_files << path if path =~ /.*\.html$/
    end
    html_files
  end

  def inject_layout(path)
    content = File.read(path)
    erb = ERB.new(File.read(File.join(base_file, "/source/layouts/default.html.erb"))).result(binding)
    File.write(path, erb)
  end

  def inject_layout_to_all
    flag_html.each do |path|
      inject_layout(path)
    end
  end

  def extract_tags
    post_lines = File.readlines(File.join(base_file,"/source/posts/2016-04-14-welcome-to-hyde.md"))
    #require 'pry'; binding.pry
    if post_lines.length != 0
      tags = post_lines[1].chomp.split
      formatted = tags.map do |tag|
        tag.gsub(",","")
      end
      tag_values = [formatted[0], formatted[1..-1]]
      @tag_hash = Hash[*tag_values]
    end
  end

end
