#===============================================================================
#  `File` class extensions
#===============================================================================
class ::File
  class << self
    #---------------------------------------------------------------------------
    #  Checks for existing file, gets around accents
    #---------------------------------------------------------------------------
    def safe?(file)
      File.open(file, 'rb')
      true
    rescue Errno::ENOENT
      false
    end
    #---------------------------------------------------------------------------
    #  Copies the source file to the destination path
    #---------------------------------------------------------------------------
    def copy(source, destination)
      data = ''
      File.open(source, 'rb') do |f|
        loop do
          buffer = f.read(4096)
          break unless buffer

          data << buffer
        end
      end
      File.delete(destination) if File.safe?(destination)
      File.open(destination, 'wb') do |f|
        f.write data
      end
    end
    #---------------------------------------------------------------------------
    #  Copies the source to the destination and deletes the source
    #---------------------------------------------------------------------------
    def move(source, destination)
      File.copy(source, destination)
      File.delete(source)
    end
    #---------------------------------------------------------------------------
  end
end
