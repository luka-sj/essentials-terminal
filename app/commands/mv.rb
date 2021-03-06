#===============================================================================
#  List directory command
#===============================================================================
class CommandMv < Commands::BaseCommand
  #  command metadata
  name        'mv'
  version     '1.0.0'
  description 'Moves specified file or directory to new location'
  argument    'source', 'Specified file to be copied'
  argument    'target', 'Location for the newly copied file'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    Dir.create(File.dirname(arguments.second))
    File.copy(arguments.first, arguments.second)
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  vaidate command
  #-----------------------------------------------------------------------------
  def validate
    validate_source(arguments.first) && validate_target(arguments.second)
  end

  def validate_source(source)
    return true if File.exist?(source)

    Console.echo_p("Unable to copy file: no such file !#{source}!.")
    false
  end

  def validate_target(target)
    target = File.dirname(target)
    return true if Dir.exist?(target)

    Console.echo_p("Unable to copy file: no such location !#{source}!.")
    false
  end
  #-----------------------------------------------------------------------------
end
