#===============================================================================
#  Change directory command
#===============================================================================
class CommandCd < Commands::BaseCommand
  #  command metadata
  name        'cd'
  version     '1.0.0'
  description 'Change current working directory'
  option      'directory', 'Change to specified directory name'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    @new_dir = options.first
    @current_dir = Env.working_dir.split('/')

    handled = try_back
    handled = try_home unless handled
    handled = try_dir  unless handled

    Console.echo_p("Changed working directory to '#{Env.working_dir}'.") if handled
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  try going back in directory tree
  #-----------------------------------------------------------------------------
  def try_back
    return false unless @new_dir == '..'

    Env.set_working_dir(@current_dir[0...-1].join('/')) if @current_dir.count > 1
    true
  end
  #-----------------------------------------------------------------------------
  #  try going to home directory (directory where app was run)
  #-----------------------------------------------------------------------------
  def try_home
    return false unless @new_dir == '~'

    Env.set_working_dir(Env.initial_directory) || true
  end
  #-----------------------------------------------------------------------------
  #  try going to directory
  #-----------------------------------------------------------------------------
  def try_dir
    @new_dir = @current_dir.push(@new_dir).join('/') unless Dir.root_path?(@new_dir)

    unless Dir.safe?(@new_dir)
      Console.echo_p("Unable to change directory: no such directory '#{@new_dir}'.")
      return false
    end

    Env.set_working_dir(@new_dir) || true
  end
  #-----------------------------------------------------------------------------
end
