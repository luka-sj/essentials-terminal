#===============================================================================
#  List directory command
#===============================================================================
class CommandMv < Commands::BaseCommand
  #  command metadata
  name        'mv'
  version     '1.0.0'
  description 'Moves specified file or directory to new location'
  option      'source', 'Specified file to be copied'
  option      'target', 'Location for the newly copied file'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    Dir.create(File.dirname(options.second))
    File.copy(options.first, options.second)
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  vaidate command
  #-----------------------------------------------------------------------------
  def validate
    validate_source(options.first) && validate_target(options.second)
  end

  def validate_source(source)
    return true if File.safe?(source)

    Console.echo('Unable to copy file: no such file ')
    Console.echo(source, :red)
    Console.echo_p('.')
    false
  end

  def validate_target(target)
    target = File.dirname(target)
    return true if Dir.safe?(target)

    Console.echo('Unable to copy file: no such location ')
    Console.echo(target, :red)
    Console.echo_p('.')
    false
  end
  #-----------------------------------------------------------------------------
end
