#===============================================================================
#  Handler module for running commands
#===============================================================================
module Commands
  module Handler
    class << self
      #-------------------------------------------------------------------------
      #  command history collection for active session
      #-------------------------------------------------------------------------
      def command_history
        @command_history ||= []
      end
      #-------------------------------------------------------------------------
      #  function to listen to user input until enter is pressed
      #-------------------------------------------------------------------------
      def get_input
        # setup default variables on input run
        history_index = nil
        input         = ''
        input_end     = ''
        # loop until forced to exit
        loop do
          input      = '' if input.nil?
          input_end  = '' if input_end.nil?
          user_input = Console.getch
          # listen to keys (mapped by byte notation)
          case Commands::Input.resolve(user_input)
          when :enter
            return Commands::Input.return(input, input_end, command_history, history_index)
          when :up
            input, input_end, history_index = Commands::Input.command_history_up(command_history, history_index)
          when :down
            input, input_end, history_index = Commands::Input.command_history_down(command_history, history_index)
          when :left
            input, input_end = Commands::Input.move_cursor_left(input, input_end)
          when :right
            input, input_end = Commands::Input.move_cursor_right(input, input_end)
          when :delete
            next if input_end.empty?

            input_end = Commands::Input.delete(input, input_end)
          when :backspace
            input = Commands::Input.backspace(input, input_end)
          else
            input = Commands::Input.write(input, input_end, user_input)
          end
        end
      end
      #-------------------------------------------------------------------------
      #  turn command name into a properly initialized object
      #-------------------------------------------------------------------------
      def get_resource(command)
        # check if command is registered
        if Commands::Registry.command?(command)
          command = Commands::Registry.from_alias(command)
          # return proper object
          "Command#{command.capitalize}".constantize
        else
          # return error
          Console.echo_p("Unable to run command: no such command `#{command}`.") if command && !command.empty?
          nil
        end
      end
      #-------------------------------------------------------------------------
      #  validate command parameters
      #-------------------------------------------------------------------------
      def validate(resource, *args)
        # get command attributes
        options = resource.get(:options)
        command = resource.get(:name)
        # run command if no additional validation is required
        return true unless options

        required = options.select { |_k, v| v[1] == :required }.map { |k, _v| k }

        return true if args.count >= required.count

        # print error message
        Console.echo_p("Unable to run command: invalid number of arguments for command `#{command}`. Expected #{required.count} but got #{args.count}.")
        false
      end
      #-------------------------------------------------------------------------
      #  try running specified command
      #-------------------------------------------------------------------------
      def try(string)
        # split input string into command and proper arguments
        input   = parse_input(string)
        command = input.first
        args    = input[1..-1]
        # try running command
        get_resource(command)&.new&.run(*args)
      end
      #-------------------------------------------------------------------------
      #  try split input into least amount of components
      #-------------------------------------------------------------------------
      def parse_input(input)
        try_single = input.to_s.scan(/(?<match>[^\s']+)|'(?<match>[^']*)'/).flatten.compact
        try_double = input.to_s.scan(/(?<match>[^\s"]+)|"(?<match>[^"]*)"/).flatten.compact

        try_single.count < try_double.count ? try_single : try_double
      end
    end
    #---------------------------------------------------------------------------
  end
end
