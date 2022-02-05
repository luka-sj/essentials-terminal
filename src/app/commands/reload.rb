#===============================================================================
#  Reload terminal command
#===============================================================================
class CommandReload < Commands::BaseCommand
  #  command metadata
  name        'reload'
  version     '1.0.0'
  description 'Reloads all scripts running in context'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    #  clear console
    Env.set_working_dir(Env.initial_directory)
    Commands::Handler.try('clear')
    Console.setup
    Console.echo_p('Starting full system reload ...', 2)
    #  reload core scripts
    Env::CORE_DIRECTORIES.each do |f|
      load f
      Console.echo_li("reloaded script '#{f}'")
      Console.echo_p
    end
    #  reload gems
    Console.echo_p
    Core::Gemfile.install
    Core::Gemfile.load
    Env.run_before_init
    #  reload application scripts
    Env::APP_DIRECTORIES.each do |f|
      load f
      Console.echo_li("reloaded script '#{f}'")
      Console.echo_p
    end
    Env.run_after_init
    #  print final message
    Console.echo_p
    Console.echo_p("System reload $successful$.", 2)
  end
  #-----------------------------------------------------------------------------
end
