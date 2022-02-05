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
  def process(*args)
    Console.echo('Opening ')
    Console.echo(args.first, :light_purple)
    Console.echo_p(' ...')
    Console.run(Env::OS.windows? ? 'start' : 'open', File.expand_path(args.first))
  end
  #-----------------------------------------------------------------------------
  #  vaidate command
  #-----------------------------------------------------------------------------
  def validate(*args)
    return true if File.safe?(File.expand_path(args.first)) || args.first.url?

    Console.echo_p("Unable to open: no such file '#{args.first}'.")
    false
  end
  #-----------------------------------------------------------------------------
end
