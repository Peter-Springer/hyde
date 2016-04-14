module BaseFile

  def base_file
    File.join(Dir.pwd, "#{@file_path}")
  end

end
