#===============================================================================
#  Open file command
#===============================================================================
class CommandOpen < Commands::BaseCommand
  #  command metadata
  name        'open'
  version     '1.0.0'
  description 'Opens specified file'
  option      'filename', 'Specified file name to open'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    Console.echo('Opening ')
    Console.echo(options.first, :light_purple)
    Console.echo_p(' ...')
    Console.run(Env::OS.windows? ? 'start' : 'open', File.expand_path(options.first))
  end
  #-----------------------------------------------------------------------------
  #  vaidate command
  #-----------------------------------------------------------------------------
  def validate
    return true if File.exist?(File.expand_path(options.first)) || options.first.url?

    Console.echo_p("Unable to open: no such file '#{options.first}'.")
    false
  end
  #-----------------------------------------------------------------------------
end
