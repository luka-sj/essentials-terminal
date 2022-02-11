#===============================================================================
#  List directory command
#===============================================================================
class CommandRm < Commands::BaseCommand
  #  command metadata
  name        'rm'
  version     '1.0.0'
  description 'Deletes specified file or directory'
  argument    'target', 'Specified file or directory to be deleted'
  option      'f', 'Force delete even if directory is not empty'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    if try_delete_directory || try_delete_file
      Console.echo_p("Successfully deleted file '#{target}'.")
    else
      Console.echo_p("Unable to delete file '#{target}'.") unless Dir.exist?(target)
    end
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  file to delete
  #-----------------------------------------------------------------------------
  def target
    @target ||= option_argument('f') || arguments.first
  end
  #-----------------------------------------------------------------------------
  #  try to delete directory
  #-----------------------------------------------------------------------------
  def try_delete_directory
    return false unless Dir.exist?(target)

    unless Dir.empty?(target) || option?('f')
      Console.echo_p("Command failed: unable to delete '#{target}'. Directory is not empty.")
      return false
    end

    true if Dir.delete_all(target)
  end
  #-----------------------------------------------------------------------------
  #  try to delete file
  #-----------------------------------------------------------------------------
  def try_delete_file
    return false if Dir.exist?(target)

    true if File.delete(target)
  end
  #-----------------------------------------------------------------------------
end
