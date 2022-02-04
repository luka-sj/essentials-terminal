#===============================================================================
#  Console message formatting
#===============================================================================
require 'io/console'
require 'io/wait'

module Console
  #-----------------------------------------------------------------------------
  class << Console
    include Extensions::MarkupOptions
    include Extensions::Markup
    #---------------------------------------------------------------------------
    #  print initial system setup info
    #---------------------------------------------------------------------------
    def setup
      echo    '============================================', :brown
      echo_h1 'Essentials Terminal', false
      echo    '============================================', :brown
      echo_p  ''
      version
    end
    #---------------------------------------------------------------------------
    #  print system version info
    #---------------------------------------------------------------------------
    def version
      echo_p  "Console Version    : #{Env::VERSION}"
      echo_p  "Essentials Version : #{Env.essentials_version}"
      echo_p  "Platform           : #{Env::OS.get}"
      echo_p  '', 2
    end
    #---------------------------------------------------------------------------
    #  render console pointer
    #---------------------------------------------------------------------------
    def pointer
      Console.echo(' ~ ', :green)
      Console.echo(ENV['USER'], :cyan)
      Console.echo(' > ')
    end
    #---------------------------------------------------------------------------
    #  wait for user input
    #---------------------------------------------------------------------------
    def await
      # render pointer
      pointer
      # get input from handler
      input = Commands::Handler.get_input
      Commands::Handler.try(input)
    end
    #---------------------------------------------------------------------------
    #  echo string into console (example short hand for common options)
    #---------------------------------------------------------------------------
    #  heading 1
    def echo_h1(msg, lbreak = true)
      echo_msg_ln markup_style("\r\n*** #{msg} ***#{lbreak ? "\r\n" : nil}", text: :brown)
    end
    #  heading 2
    def echo_h2(msg, **options)
      echo_msg_ln markup_style("\r\n#{msg}\r\n", **options)
    end
    #  heading 3
    def echo_h3(msg)
      echo_msg_ln markup("\r\n#{msg}\r\n")
    end
    #  list item
    def echo_li(msg, pad = 0, color = :brown)
      echo_msg markup_style('  -> ', text: color)
      pad = (pad - msg.length) > 0 ? '.' * (pad - msg.length) : ''
      echo_msg markup(msg + pad)
    end
    #  paragraph with markup
    def echo_p(msg = '', breaks = 1)
      echo_msg markup(msg)
      breaks.times { echo_msg_ln '' }
    end
    #  string with markup
    def echo(msg, color = :default, background = :default)
      echo_msg markup_style(msg, text: color, background: background)
    end
    #  status output
    def echo_status(status)
      echo_msg_ln status ? markup_style('done', text: :green) : markup_style('error', text: :red)
    end
    #  flush current line
    def flush(offset = 0)
      STDOUT.erase_line(offset)
      STDOUT.goto_column(0)
      STDOUT.flush
    end
    #  run command
    def run(command, *args)
      system command, *args
    end
    #---------------------------------------------------------------------------
    #  record input
    #---------------------------------------------------------------------------
    def getch
      input = STDIN.getch.chomp
      input << STDIN.getch.chomp while STDIN.ready?
      input
    end
    #---------------------------------------------------------------------------
    #  syntax highlighting for console output
    #---------------------------------------------------------------------------
    def syntax_highlighting(string, syntax = 'Ruby')
      formatter = Rouge::Formatters::Terminal256.new
      lexer = "Rouge::Lexers::#{syntax}".constantize.new

      formatter.format(lexer.lex(string))
    end
    #---------------------------------------------------------------------------
    #  private echo functions
    #---------------------------------------------------------------------------
    private
    #  standard echo message
    def echo_msg(msg)
      print msg
    end
    #  standard echo message with newline
    def echo_msg_ln(msg)
      print "#{msg}\r\n"
    end
    #---------------------------------------------------------------------------
  end
end