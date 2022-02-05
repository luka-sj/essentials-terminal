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
    return if try_delete_directory(options.first)

    return if try_delete_file(options.first)

    Console.echo('Command failed: unable to delete ')
    Console.echo(options.first, :light_purple)
    Console.echo_p('.')
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  try to delete directory
  #-----------------------------------------------------------------------------
  def try_delete_directory(target)
    return false unless Dir.safe?(target)

    return false unless Dir.empty?(target) || flag?('f')

    true if Dir.delete_all(target)
  end
  #-----------------------------------------------------------------------------
  #  try to delete file
  #-----------------------------------------------------------------------------
  def try_delete_file(target)
    return false if Dir.safe?(target)

    true if File.delete(target)
  end
  #-----------------------------------------------------------------------------
end
