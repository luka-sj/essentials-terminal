#===============================================================================
#  Pry environment command
#===============================================================================
class CommandPry < Commands::BaseCommand
  #  command metadata
  name        'pry'
  version     '1.0.0'
  description 'Run interactive Ruby session to debug current context'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    #  pry called from CommandPry#process
    #  opened a new interactive Ruby session
    #  from here, you have access to all system/environment variables or modules
    #  when done with the session, run the command `exit` to close the session
    binding.pry
  end
  #-----------------------------------------------------------------------------
end
