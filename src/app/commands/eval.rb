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
    output = eval(args.first, TOPLEVEL_BINDING, __FILE__, __LINE__)
    Console.echo_p(Console.syntax_highlighting(output.to_s))
  end
  #-----------------------------------------------------------------------------
end
