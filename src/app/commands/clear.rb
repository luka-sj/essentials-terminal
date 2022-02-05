#===============================================================================
#  Clear terminal output command
#===============================================================================
class CommandClear < Commands::BaseCommand
  #  command metadata
  name        'clear'
  version     '1.0.0'
  description 'Clear current console content'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    action = Env::OS.windows? ? 'cls' : 'clear'
    Console.run(action)
  end
  #-----------------------------------------------------------------------------
end
