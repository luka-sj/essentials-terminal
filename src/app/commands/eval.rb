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
    eval("puts 'eval:'; puts #{args.first}", TOPLEVEL_BINDING, __FILE__, __LINE__)
  rescue StandardError
    Console.echo_p('Unable to run `eval` given code:')
    Console.echo_p($ERROR_INFO.message)
  end
  #-----------------------------------------------------------------------------
end
