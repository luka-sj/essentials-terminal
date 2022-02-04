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
    #  fail if not URL and file does not exist
    return Console.echo_p("Unable to open: no such file '#{args.first}'.") unless File.safe?(args.first) || args.first.url?

    Console.echo('Opening ')
    Console.echo(args.first, :light_purple)
    Console.echo_p(' ...')
    Console.run(Env::OS.windows? ? 'start' : 'open', args.first)
  end
  #-----------------------------------------------------------------------------
end
