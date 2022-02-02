#===============================================================================
#  `Dir` class extensions
#===============================================================================
class ::Dir
  #-----------------------------------------------------------------------------
  #  Reads all files in a directory
  #-----------------------------------------------------------------------------
  def self.get(dir, filters = "*", full = true)
    files = []
    filters = [filters] if !filters.is_a?(Array)
    self.chdir(dir) do
      filters.each do |filter|
        self.glob(filter) { |f| files.push(full ? (dir + "/" + f) : f) }
      end
    end
    return files.sort
  end
  #-----------------------------------------------------------------------------
  #  Generates entire file/folder tree from a certain directory
  #-----------------------------------------------------------------------------
  def self.all(dir, filters = "*", full = true)
    # sets variables for starting
    files = []
    subfolders = []
    self.get(dir, filters, full).each do |file|
      # engages in recursion to read the entire file tree
      if self.safe?(file)   # Is a directory
        subfolders += self.all(file, filters, full)
      else   # Is a file
        files += [file]
      end
    end
    # returns all found files
    return files + subfolders
  end
  #-----------------------------------------------------------------------------
  #  Checks for existing directory, gets around accents
  #-----------------------------------------------------------------------------
  def self.safe?(dir)
    return false if !FileTest.directory?(dir)
    ret = false
    self.chdir(dir) { ret = true } rescue nil
    return ret
  end
  #-----------------------------------------------------------------------------
  #  Creates all the required directories for filename path
  #-----------------------------------------------------------------------------
  def self.create(path)
    path.gsub!("\\", "/") # Windows compatibility
    # get path tree
    dirs = path.split("/"); full = ""
    for dir in dirs
      full += dir + "/"
      # creates directories
      self.mkdir(full) if !self.safe?(full)
    end
  end
  #-----------------------------------------------------------------------------
  #  Generates entire file/folder tree from a certain directory
  #-----------------------------------------------------------------------------
  def self.all_dirs(dir)
    # sets variables for starting
    dirs = []
    for file in self.get(dir, "*", true)
      # engages in recursion to read the entire folder tree
      dirs += self.all_dirs(file) if self.safe?(file)
    end
    # returns all found directories
    return dirs.length > 0 ? (dirs + [dir]) : [dir]
  end
  #-----------------------------------------------------------------------------
  #  Deletes all the files in a directory and all the sub directories (allows for non-empty dirs)
  #-----------------------------------------------------------------------------
  def self.delete_all(dir)
    # delete all files in dir
    self.all(dir).each { |f| File.delete(f) }
    # delete all dirs in dir
    self.all_dirs(dir).each { |f| Dir.delete(f) }
  end
  #-----------------------------------------------------------------------------
  #  Checks if specified path is root
  #-----------------------------------------------------------------------------
  def self.root_path?(path)
    return true if path.scan(/^[a-zA-Z]:.*$/).count > 0
    return true if path.scan(/^\/.*$/).count > 0
    return false
  end
  #-----------------------------------------------------------------------------
end
