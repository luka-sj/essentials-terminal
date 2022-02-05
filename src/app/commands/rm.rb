#===============================================================================
#  List directory command
#===============================================================================
class CommandRm < Commands::BaseCommand
  #  command metadata
  name        'rm'
  version     '1.0.0'
  description 'Deletes specified file or directory'
  option      'target', 'Specified file or directory to be deleted'
  flag        'f', 'Force delete even if directory is not empty'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    if try_delete_directory || try_delete_file
      Console.echo_p("Successfully deleted file '#{options.first}'.")
    else
      Console.echo_p("Unable to delete file '#{options.first}'.") unless Dir.exist?(options.first)
    end
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  try to delete directory
  #-----------------------------------------------------------------------------
  def try_delete_directory
    return false unless Dir.exist?(options.first)

    unless Dir.empty?(options.first) || flag?('f')
      Console.echo_p("Command failed: unable to delete '#{options.first}'. Directory is not empty.")
      return false
    end

    true if Dir.delete_all(options.first)
  end
  #-----------------------------------------------------------------------------
  #  try to delete file
  #-----------------------------------------------------------------------------
  def try_delete_file
    return false if Dir.exist?(options.first)

    true if File.delete(options.first)
  end
  #-----------------------------------------------------------------------------
end
