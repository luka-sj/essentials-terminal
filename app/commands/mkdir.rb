#===============================================================================
#  Make directory command
#===============================================================================
class CommandMkdir < Commands::BaseCommand
  #  command metadata
  name        'mkdir'
  version     '1.0.0'
  description 'Create new directory'
  argument    'directory', 'Specified directory path to create'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    Thread.new { Dir.create(arguments.first) }
    Env.sync_working_dir

    Console.echo_p("Successfully created directory '#{arguments.first}'.")
  end
  #-----------------------------------------------------------------------------
end
