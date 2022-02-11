#===============================================================================
#  Eval application command
#===============================================================================
class CommandEval < Commands::BaseCommand
  #  command metadata
  name        'eval'
  version     '1.0.0'
  description 'Run Ruby code on the fly'
  argument    'code', 'String containing code to run'

  register
  #-----------------------------------------------------------------------------
  #  process command action
  #-----------------------------------------------------------------------------
  def process
    output = eval(arguments.first, TOPLEVEL_BINDING, __FILE__, __LINE__)
    print Console.syntax_highlighting(output.to_s)
    print "\r\n"
  end
  #-----------------------------------------------------------------------------
end
