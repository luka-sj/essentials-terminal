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
  def process(*args)
    Dir.create(args[1].gsub('\\', '/').split('/')[0...-1].join('/'))
    File.copy(args[0], args[1])
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  vaidate command
  #-----------------------------------------------------------------------------
  def validate(*args)
    validate_source(args[0]) && validate_target(args[0], args[1])
  end

  def validate_source(source)
    return true if File.safe?(source)

    Console.echo('Unable to copy file: no such file ')
    Console.echo(source, :red)
    Console.echo_p('.')
    false
  end

  def validate_target(source, target)
    return true unless source == target

    Console.echo_p('Unable to copy file: target cannot be the same as source file.')
    false
  end
  #-----------------------------------------------------------------------------
end
