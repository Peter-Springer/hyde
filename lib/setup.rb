require 'FileUtils'
class Setup

  def new_project_skeleton(project_file_path)
    FileUtils.mkdir_p 'project_file_path'
  end

  def create_folder(file_name)
    FileUtils.cd
    FileUtils.mkdir_p(file_name)
  end
  #
  # def create_file
  #
  # end

end
