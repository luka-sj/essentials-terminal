#===============================================================================
#  System version command
#===============================================================================
class CommandVersion < Commands::BaseCommand
  #  command metadata
  name        'version'
  version     '1.0.0'
  description 'Display cirrent version info'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process(*_args)
    Console.version
  end
  #-----------------------------------------------------------------------------
end
