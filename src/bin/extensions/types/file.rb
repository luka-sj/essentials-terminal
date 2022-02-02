#===============================================================================
#  `File` class extensions
#===============================================================================
class ::File
  #-----------------------------------------------------------------------------
  #  Checks for existing file, gets around accents
  #-----------------------------------------------------------------------------
  def self.safe?(file)
    ret = false
    self.open(file, 'rb') { ret = true } rescue nil
    return ret
  end
  #-----------------------------------------------------------------------------
  #  Copies the source file to the destination path
  #-----------------------------------------------------------------------------
  def self.copy(source, destination)
    data = ""
    t = Time.now
    File.open(source, 'rb') do |f|
      loop do
        r = f.read(4096)
        break if !r
        if Time.now - t > 1
          Graphics.update
          t = Time.now
        end
        data += r
      end
    end
    File.delete(destination) if File.file?(destination)
    f = File.new(destination, 'wb')
    f.write data
    f.close
  end
  #-----------------------------------------------------------------------------
  #  Copies the source to the destination and deletes the source
  #-----------------------------------------------------------------------------
  def self.move(source, destination)
    File.copy(source, destination)
    File.delete(source)
  end
  #-----------------------------------------------------------------------------
  #  Checks if .rxdata file exists
  #-----------------------------------------------------------------------------
  def self.safeData?(file)
    ret = false
    ret = (load_data(file) ? true : false) rescue false
    return ret
  end
  #-----------------------------------------------------------------------------
end
