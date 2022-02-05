#===============================================================================
#  Clear terminal output command
#===============================================================================
class CommandEssentials < Commands::BaseCommand
  #  command metadata
  name        'essentials'
  version     '1.0.0'
  description 'Run essentials environment'
  option      'load', 'Load Essentials content from current working directory'
  option      'eval', 'Run code from the Essentials environment', :alternative

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    #  check subcommand
    case options.first
    when 'load'
      Env.load_essentials_scripts
    when 'eval'
      eval_essentials_code(options.second)
    end
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  run Essentials content
  #-----------------------------------------------------------------------------
  def eval_essentials_code(code)
    return Console.echo_p('Unable to eval: Essentials scripts not loaded. Run `essentials load` first.') unless Env.essentials_loaded?

    Console.echo_p(Env.essentials_binding.instance_eval(code))
  end
  #-----------------------------------------------------------------------------
  #  vaidate command
  #-----------------------------------------------------------------------------
  def validate
    unless File.exist?("#{Env.working_dir}/Game.rxproj") && File.exist?("#{Env.working_dir}/Data/Scripts.rxdata")
      Console.echo('Unable to load project: ')
      Console.echo('no valid project found.', :red)
      Console.echo_p
      return false
    end

    true
  end
  #-----------------------------------------------------------------------------
end
