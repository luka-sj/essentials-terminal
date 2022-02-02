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
  def process(*args)
    action = ENV['OS'] == 'Windows_NT' ? 'cls' : 'clear'
    Console.run(action)
  end
  #-----------------------------------------------------------------------------
end
