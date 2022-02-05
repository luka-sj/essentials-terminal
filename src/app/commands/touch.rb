#===============================================================================
#  Touch file command
#===============================================================================
class CommandTouch < Commands::BaseCommand
  #  command metadata
  name        'touch'
  version     '1.0.0'
  description 'Creates new empty file'
  option      'file', 'Specified file path to create'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    Thread.new { File.open(options.first, 'w') { |f| f.write('') } }
    Env.sync_working_dir

    Console.echo("Successfully created file '#{options.first}'.")
  end
  #-----------------------------------------------------------------------------
end
