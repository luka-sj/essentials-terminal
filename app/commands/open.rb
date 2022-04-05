#===============================================================================
#  Open file command
#===============================================================================
class CommandOpen < Commands::BaseCommand
  #  command metadata
  name        'open'
  version     '1.0.0'
  description 'Opens specified file'
  argument    'filename', 'Specified file name to open'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    Console.echo_p("Opening '#{arguments.first}' ...")
    Console.run(Env::OS.windows? ? 'start' : 'open', File.expand_path(arguments.first))
  end
  #-----------------------------------------------------------------------------
  #  vaidate command
  #-----------------------------------------------------------------------------
  def validate
    return true if File.exist?(File.expand_path(arguments.first)) || arguments.first.url?

    Console.echo_p("Unable to open: no such file '#{arguments.first}'.")
    false
  end
  #-----------------------------------------------------------------------------
end
