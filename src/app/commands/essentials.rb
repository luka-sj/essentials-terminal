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
      Env.load_essentials_scripts
    when 'eval'
      eval_essentials_code(args[1])
    end
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  run Essentials content
  #-----------------------------------------------------------------------------
  def eval_essentials_code(code)
    return Console.echo_p('Unable to eval: Essentials scripts not loaded. Run `essentials load` first.') unless Env.essentials_loaded?

    Console.echo_p(eval(code, Env.essentials_binding, __FILE__, __LINE__))
  end
  #-----------------------------------------------------------------------------
  #  vaidate command
  #-----------------------------------------------------------------------------
  def validate(*_args)
    unless File.safe?("#{Env.working_dir}/Game.rxproj") && File.safe?("#{Env.working_dir}/Data/Scripts.rxdata")
      Console.echo('Unable to load project: ')
      Console.echo('no valid project found.', :red)
      Console.echo_p
      return false
    end

    true
  end
  #-----------------------------------------------------------------------------
end
