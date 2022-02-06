#===============================================================================
#  Console progress_bar output
#===============================================================================
require 'io/console'

module Console
  class ProgressBar
    #---------------------------------------------------------------------------
    #  class constructor
    #---------------------------------------------------------------------------
    def initialize(content_length)
      @content_length = content_length
      #  dynamically get console width (character number)
      @console_width  = STDIN.winsize.second - 8
    end
    #---------------------------------------------------------------------------
    #  set progress for bar and print output
    #---------------------------------------------------------------------------
    def set(progress, flush = true)
      #  define required variables
      percentage     = "#{progress.to_i}".rjust(3, ' ') + '% '
      progress_chars = (@console_width * progress/100.0).to_i
      blank_chars    = @console_width - progress_chars
      #  print to console
      STDOUT.goto_column(0) if flush
      Console.echo_p("#{percentage} [$#{'=' * progress_chars}$#{'-' * blank_chars}]", 0)
    end
    #---------------------------------------------------------------------------
    #  finish progress bar rendering
    #---------------------------------------------------------------------------
    def done
      set(100)
      Console.echo_p('', 2)
    end
    #---------------------------------------------------------------------------
  end
end
