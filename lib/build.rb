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
    @tag_link_hash = {}
  end

  def build
    if Dir.exist?(base_file)
      copy_source
      build_tag_directory
      extract_tags
      clean_up_tag_names
      build_tag_files
      flag_markdowns
      write_tag_links_for_every_post
      convert_md_to_html
      inject_layout_to_all
    else
      setup.new_project_skeleton
      copy_source
      build_tag_directory
      extract_tags
      clean_up_tag_names
      build_tag_files
      flag_markdowns
      write_tag_links_for_every_post
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

  def read_file(path)
    File.readlines(path)
  end

  def extract_tags
    formatted = []
    flag_markdowns.each do |path|
    read_file(path)
    if read_file(path).length != 0
        tags = read_file(path)[1][6..-1].chomp.split(", ")
        tags.each do |tag|
          formatted << tag.gsub(",","")
        end
      end
    end
    @tag_hash["keys:"] = formatted
  end

  def clean_up_tag_names
    tag_names = @tag_hash.values
    formatted = tag_names.map do |keys|
      keys.map do |tag|
        tag.downcase.gsub(" ", "_")
      end
    end
    formatted
  end

  def build_tag_directory
    FileUtils.mkdir_p(File.join(base_file, "/output/tags"))
  end

  def build_tag_files
    unique_tags = clean_up_tag_names[0].uniq
    unique_tags.each do |tag|
      new_file = File.join(base_file,"/output/tags/#{tag}.html")
      FileUtils.touch (new_file)
      @tag_link_hash[tag] = new_file
    end
  end

  def extract_tags_single_file(path)
    formatted = []
    read_file(path)
    if read_file(path).length != 0
        tags = read_file(path)[1][6..-1].chomp.split(", ")
        tags.each do |tag|
          formatted << tag.gsub(",","")
        end
      end
    formatted
  end

  def write_tag_links_in_post(path)
    extract_tags_single_file(path).each do |tag|
      if @tag_hash.values[0].include?(tag)
        File.open(path, 'a') do |file|
          file.write "#{@tag_link_hash[tag.downcase.gsub(" ", "_")]}\n"
        end
      end
    end
  end

  def write_tag_links_for_every_post
    flag_markdowns.each do |path|
      write_tag_links_in_post(path)
    end
  end

end
