require 'io/console'
#===============================================================================
#  Handler module for running commands
#===============================================================================
module Commands
  module Handler
    #  command history collection for active session
    @@command_history = []
    #---------------------------------------------------------------------------
    #  function to listen to user input until enter is pressed
    #---------------------------------------------------------------------------
    def self.get_input
      # setup default variables on input run
      history_index = nil
      input         = ''
      input_end     = ''
      # loop until forced to exit
      loop do
        input      = '' if input.nil?
        input_end  = '' if input_end.nil?
        user_input = $stdin.getch
        # listen to keys (mapped by byte notation)
        case Commands::Input.keys_binary[user_input.bytes.join(',')]
        when :enter
          return Commands::Input.return(input, input_end, @@command_history, history_index)
        when :up
          input, input_end, history_index = Commands::Input.command_history_up(@@command_history, history_index)
        when :down
          input, input_end, history_index = Commands::Input.command_history_down(@@command_history, history_index)
        when :left
          input, input_end = Commands::Input.move_cursor_left(input, input_end)
        when :right
          input, input_end = Commands::Input.move_cursor_right(input, input_end)
        when :delete
          next unless input_end.length > 0

          input_end = Commands::Input.delete(input, input_end)
        when :backspace
          input = Commands::Input.backspace(input, input_end)
        else
          input = Commands::Input.write(input, input_end, user_input)
        end
      end
    end
    #---------------------------------------------------------------------------
    #  turn command name into a properly initialized object
    #---------------------------------------------------------------------------
    def self.get_resource(command)
      # check if command is registered
      if Commands::Registry.has_command?(command)
        command = Commands::Registry.from_alias(command)
        # return proper object
        return "Command#{command.sub(/^\w/) { $&.upcase }}".constantize
      else
        # return error
        Console.echo_p("Unable to run command: no such command `#{command}`.") if command && !command.empty?
        return nil
      end
    end
    #---------------------------------------------------------------------------
    #  validate command parameters
    #---------------------------------------------------------------------------
    def self.validate(resource, *args)
      # get command attributes
      options = resource.get(:options)
      command = resource.get(:name)
      # run command if no additional validation is required
      return true unless options
      return true if args.count >= options.count
      # print error message
      Console.echo_p("Unable to run command: invalid number of arguments for command `#{command}`. Expected #{options.count} but got #{args.count}.")
      return false
    end
    #---------------------------------------------------------------------------
    #  try running specified command
    #---------------------------------------------------------------------------
    def self.try(string)
      # split input string into command and proper arguments
      input   = parse_input(string)
      command = input.first
      args    = input[1..-1]
      # try running command
      begin
        get_resource(command)&.new&.run(*args)
      rescue
        Console.echo_p("Unable to run command: error running command `#{command}`:")
        Console.echo_p($!.message)
      end
    end
    #---------------------------------------------------------------------------
    #  try split input into least amount of components
    #---------------------------------------------------------------------------
    def self.parse_input(input)
      try_single = input.to_s.scan(/(?<match>[^\s']+)|'(?<match>[^']*)'/).flatten.compact
      try_double = input.to_s.scan(/(?<match>[^\s"]+)|"(?<match>[^"]*)"/).flatten.compact

      return try_single.count < try_double.count ? try_single : try_double
    end
    #---------------------------------------------------------------------------
  end
end
