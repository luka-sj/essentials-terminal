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

    Console.echo("Successfully created directory ")
    Console.echo(options.first, :light_purple)
    Console.echo_p
  rescue StandardError
    Console.echo("Failed to create directory ")
    Console.echo(options.first, :light_purple)
    Console.echo_p($ERROR_INFO.backtrace)
  end
  #-----------------------------------------------------------------------------
end
