#===============================================================================
#  Clear terminal output command
#===============================================================================
class CommandRun < Commands::BaseCommand
  #  command metadata
  name        'clear'
  version     '1.0.0'
  description 'Run specified Ruby task'
  argument    'task_name'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    Commands::Task.run(arguments.first)
  end
  #-----------------------------------------------------------------------------
end
