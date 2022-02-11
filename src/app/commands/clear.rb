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
    Console.run(Env::OS.windows? ? 'cls' : 'clear')
  end
  #-----------------------------------------------------------------------------
end
