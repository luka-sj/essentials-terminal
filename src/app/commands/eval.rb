#===============================================================================
#  Eval application command
#===============================================================================
class CommandEval < Commands::BaseCommand
  #  command metadata
  name        'eval'
  version     '1.0.0'
  description 'Run Ruby code on the fly'
  option      'code', 'String containing code to run'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process(*args)
    begin
      eval("puts 'eval:'; puts #{args.first}")
    rescue
      Console.echo_p("Unable to run `eval` given code:")
      Console.echo_p($!.message)
    end
  end
  #-----------------------------------------------------------------------------
end
