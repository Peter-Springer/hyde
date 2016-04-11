require 'FileUtils'
class Setup

  def new_project_skeleton(project_file_path)
    if Dir.exists?("#{project_file_path}")
      raise ArgumentError.new("directory already exists")
    else
      Dir.mkdir("#{project_file_path}")
    end
    #create new directory
    #return error if directory already exists
    #fill new directory
  end

  # def create_folder(file_name)


  # end

  def create_folder(file_name)

  end
  #
  # def create_file
  #
  # # end
  # #
  # # def create_file
  # #
  # # end

end
