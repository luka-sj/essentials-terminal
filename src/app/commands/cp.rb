#===============================================================================
#  List directory command
#===============================================================================
class CommandCp < Commands::BaseCommand
  #  command metadata
  name        'cp'
  version     '1.0.0'
  description 'Copies specified file or directory to new location'
  option      'source', 'Specified file to be copied'
  option      'target', 'Location for the newly copied file'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    Dir.create(options.second.gsub('\\', '/').split('/')[0...-1].join('/'))
    File.copy(options.first, options.second)
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  vaidate command
  #-----------------------------------------------------------------------------
  def validate
    validate_source(options.first) && validate_target(options.first, options.second)
  end

  def validate_source(source)
    return true if File.exist?(source)

    Console.echo_p("Unable to copy file: no such file !#{source}!.")
    false
  end

  def validate_target(source, target)
    return true unless source == target

    Console.echo_p('Unable to copy file: target cannot be the same as source file.')
    false
  end
  #-----------------------------------------------------------------------------
end
