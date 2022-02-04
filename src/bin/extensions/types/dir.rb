#===============================================================================
#  `Dir` class extensions
#===============================================================================
class ::Dir
  class << self
    #---------------------------------------------------------------------------
    #  Reads all files in a directory
    #---------------------------------------------------------------------------
    def get(dir, filters = '*', full = true)
      files = []
      filters = [filters] unless filters.is_a?(Array)
      chdir(dir) do
        filters.each do |filter|
          glob(filter) { |f| files.push(full ? "#{dir}/#{f}" : f) }
        end
      end

      files.sort
    end
    #---------------------------------------------------------------------------
    #  Generates entire file/folder tree from a certain directory
    #---------------------------------------------------------------------------
    def all(dir, filters = '*', full = true)
      # sets variables for starting
      files = []
      subfolders = []
      get(dir, filters, full).each do |file|
        # engages in recursion to read the entire file tree
        if safe?(file) # Is a directory
          subfolders += all(file, filters, full)
        else # Is a file
          files += [file]
        end
      end
      # returns all found files
      files + subfolders
    end
    #---------------------------------------------------------------------------
    #  Checks for existing directory, gets around accents
    #---------------------------------------------------------------------------
    def safe?(dir)
      return false unless FileTest.directory?(dir)

      chdir(dir)
      true
    rescue Errno::ENOENT
      false
    end
    #---------------------------------------------------------------------------
    #  Checks if directory is empty
    #---------------------------------------------------------------------------
    def empty?(dir)
      get(dir).empty?
    end
    #---------------------------------------------------------------------------
    #  Creates all the required directories for filename path
    #---------------------------------------------------------------------------
    def create(path)
      path.gsub!('\\', '/') # Windows compatibility
      # get path tree
      dirs = path.split('/')
      full_string = ''
      dirs.each do |dir|
        full_string << "#{dir}/"
        # creates directories
        mkdir(full) unless safe?(full)
      end
    end
    #---------------------------------------------------------------------------
    #  Generates entire file/folder tree from a certain directory
    #---------------------------------------------------------------------------
    def all_dirs(dir)
      # sets variables for starting
      dirs = get(dir, '*', true).each.map do |file|
        # engages in recursion to read the entire folder tree
        all_dirs(file) if safe?(file)
      end
      # returns all found directories
      dirs.empty? ? [dir] : (dirs + [dir])
    end
    #---------------------------------------------------------------------------
    #  Deletes all the files in a directory and all the sub directories (allows for non-empty dirs)
    #---------------------------------------------------------------------------
    def delete_all(dir)
      # delete all files in dir
      all(dir).each { |f| File.delete(f) }
      # delete all dirs in dir
      all_dirs(dir).each { |d| Dir.delete(d) }
    end
    #---------------------------------------------------------------------------
    #  Checks if specified path is root
    #---------------------------------------------------------------------------
    def root_path?(path)
      return true if path.scan(/^[a-zA-Z]:.*$/).count > 0

      return true if path.scan(/^\/.*$/).count > 0

      false
    end
    #---------------------------------------------------------------------------
  end
end
