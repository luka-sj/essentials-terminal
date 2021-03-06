#===============================================================================
#  List directory command
#===============================================================================
class CommandLs < Commands::BaseCommand
  #  command metadata
  name        'ls'
  version     '1.0.0'
  description 'Displays current working directory'
  option      'l', 'List all files and directories in working directory'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    #  show folder content if option is specified
    return echo_working_directory_content if option?('l')

    #  return working directory
    echo_working_directory
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  print out current working directory location
  #-----------------------------------------------------------------------------
  def echo_working_directory
    Console.echo_p("Current working directory: '#{Env.working_dir}'")
  end
  #-----------------------------------------------------------------------------
  #  print out current working directory content
  #-----------------------------------------------------------------------------
  def echo_working_directory_content
    #  get all folder content
    dirs = Dir.get(Env.working_dir)
    Console.echo_p("Currently in the '#{Env.working_dir}' directory: ")
    #  iterate through each and print to console
    dirs.each do |dir|
      file_dir = dir.split('/').last
      Console.echo_li(Dir.exist?(dir) ? "'#{file_dir}/'" : file_dir)
      Console.echo_p
    end
    Console.echo_p
  end
  #-----------------------------------------------------------------------------
end
