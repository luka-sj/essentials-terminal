#===============================================================================
#  History command
#===============================================================================
class CommandHistory < Commands::BaseCommand
  #  command metadata
  name        'history'
  version     '1.0.0'
  description 'Show entire command history'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    Console.echo_p('History of used commands for current session:')
    Commands::Handler.command_history.each do |cmd|
      Console.echo_li(cmd)
      Console.echo_p
    end
  end
  #-----------------------------------------------------------------------------
end
