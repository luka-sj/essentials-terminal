#===============================================================================
#  Clear terminal output command
#===============================================================================
class CommandEssentials < Commands::BaseCommand
  #  command metadata
  name        'essentials'
  version     '1.0.0'
  description 'Run essentials environment'
  option      'load', 'Load Essentials content from current working directory'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process(*args)
    #  check subcommand
    case args.first
    when 'load'
      load_essentials
    end
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  load Essentials content
  #-----------------------------------------------------------------------------
  def load_essentials
    unless File.safe?("#{Env.working_dir}/Game.rxproj") && File.safe?("#{Env.working_dir}/Data/Scripts.rxdata")
      Console.echo('Unable to load project: ')
      Console.echo('no valid project found.', :red)
      Console.echo_p
      return false
    end

    # TODO: the rest of the functionality
    true
  end
  #-----------------------------------------------------------------------------
end
