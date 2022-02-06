#===============================================================================
#  `File` class extensions
#===============================================================================
class ::File
  class << self
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
      File.delete(destination) if File.exist?(destination)
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
    #  Extract contents of zip file
    #---------------------------------------------------------------------------
    def extract(file)
      Console.echo_p("Extracting contents from '#{file}' ...", 2)
      open(file, 'r') do |f|
        #  open Zip buffer
        Zip::File.open_buffer(f.read) do |zip|
          progress_bar = Console::ProgressBar.new(zip.count)
          progress_bar.set(0)

          zip.each_with_index do |entry, i|
            #  create necessary directories
            new_dir = File.dirname(entry.name)
            Dir.create(new_dir) unless new_dir == '.'

            #  extract directory
            entry.extract
            progress = (i + 1).quo(zip.count) * 100
            progress_bar.set(progress)
          end
          progress_bar.done
        end
      end
      #  delete file after extraction
      delete(file)
    end
    #---------------------------------------------------------------------------
  end
end
