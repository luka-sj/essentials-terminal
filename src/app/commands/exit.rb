#===============================================================================
#  Exit application command
#===============================================================================
class CommandExit < Commands::BaseCommand
  #  command metadata
  name        'exit'
  version     '1.0.0'
  description 'Exits current session'
  aliases     'shutdown', 'quit'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process(*_args)
    Console.echo_p('Exiting application ...', 2)
    exit!
  end
  #-----------------------------------------------------------------------------
end
