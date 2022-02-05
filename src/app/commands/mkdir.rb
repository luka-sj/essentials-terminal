#===============================================================================
#  Make directory command
#===============================================================================
class CommandMkdir < Commands::BaseCommand
  #  command metadata
  name        'mkdir'
  version     '1.0.0'
  description 'Create new directory'
  option      'directory', 'Specified directory path to create'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    Thread.new { Dir.create(options.first) }
    Env.sync_working_dir

    Console.echo_p("Successfully created directory '#{options.first}'.")
  end
  #-----------------------------------------------------------------------------
end
