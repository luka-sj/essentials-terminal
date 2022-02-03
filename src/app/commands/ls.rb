#===============================================================================
#  List directory command
#===============================================================================
class CommandLs < Commands::BaseCommand
  #  command metadata
  name        'ls'
  version     '1.0.0'
  description 'Displays current working directory'
  flag        'l', 'List all files and directories in working directory'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process(*_args)
    #  show folder content if flag is specified
    if flag?('l')
      #  get all folder content
      dirs = Dir.get(Env.working_dir)
      Console.echo_p("Currently in the '#{Env.working_dir}' directory:")
      #  iterate through each and print to console
      dirs.each do |dir|
        file_dir = dir.split('/').last
        Console.echo_li(Dir.safe?(dir) ? "'#{file_dir}/'" : file_dir)
        Console.echo_p
      end
      return Console.echo_p
    end
    #  return working directory
    Console.echo('Current working directory:')
    Console.echo(Env.working_dir, :light_purple)
    Console.echo_p
  end
  #-----------------------------------------------------------------------------
end
