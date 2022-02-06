#===============================================================================
#  Clear terminal output command
#===============================================================================
require 'json'

class CommandEssentials < Commands::BaseCommand
  #  command metadata
  name        'essentials'
  version     '1.0.0'
  description 'Run essentials environment'
  option      'load', 'Load Essentials content from current working directory'
  option      'eval', 'Run code from the Essentials environment', :alternative
  option      'pack', 'Essentials plugin to install', :load

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
    when 'init'
      init_essentials_project
    when 'install'
      install_essentials_pack
    end
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  run Essentials bound code
  #-----------------------------------------------------------------------------
  def eval_essentials_code(code)
    return Console.echo_p('Unable to eval: Essentials scripts not loaded. Run `essentials load` first.') unless Env.essentials_loaded?

    Console.echo_p(Env.essentials_binding.instance_eval(code))
  end
  #-----------------------------------------------------------------------------
  #  download and extract latest release of Essentials
  #-----------------------------------------------------------------------------
  def init_essentials_project
    return Console.echo_p('Cannot create Essentials project. Directory is not empty.') unless Dir.empty?(Env.working_dir)

    #  get the latest version info from server
    Console.echo_p("Searching repository 'https://luka-sj.com/res' for latest version of Essentials ...", 0)
    essentials_info = JSON.parse(Modules::HTTP.get('https://luka-sj.com/api/essentials/latest/version'))
    Console.echo_p(" found $#{essentials_info['VERSION']}$.")

    temp_file = "essentials_release_#{essentials_info['VERSION']}.zip"

    #  download Essentials to a local temporary file
    Console.echo_p("Downloading from repository 'https://luka-sj.com/res' instance of essentials@release:$latest$ ...", 2)
    Modules::HTTP.download("https://luka-sj.com/api/download/#{essentials_info['PACK']}", file: temp_file, progress_bar: true)
    Console.echo_p("Download of instance essentials@release:latest $complete$.", 2)

    #  extract the contents of the downloaded file
    File.extract(temp_file)
    Console.echo_p

    #  print final output message
    Console.echo_p("Essentials $v#{19}$ has been $successfully$ installed.", 2)
  end
  #-----------------------------------------------------------------------------
  #  install specific Essentials plugin
  #-----------------------------------------------------------------------------
  def install_essentials_pack
    #  validate input argument
    pack = options.second.nil? || options.second.empty? ? 'nil' : options.second
    return Console.echo_p("Invalid plugin name given: received !#{pack}!.") if pack == 'nil'

    #  validate pack content
    pack_info = get_pack_info
    return Console.echo_p("Unable to install plugin: could not find any info in repository for !#{pack}!.")

  end
  #-----------------------------------------------------------------------------
  #  get specified plugin info
  #-----------------------------------------------------------------------------
  def get_pack_info
    JSON.parse(Modules::HTTP.get("https://luka-sj.com/api/pack/#{options.second}"))
  end
  #-----------------------------------------------------------------------------
  #  vaidate command
  #-----------------------------------------------------------------------------
  def validate
    return true if ['init', 'eval'].include?(options.first)

    unless Env.essentials_dir?
      Console.echo_p("Unable to load project: !no valid project found!.")
      return false
    end

    true
  end
  #-----------------------------------------------------------------------------
end
