#===============================================================================
#  Input module for running commands
#===============================================================================
module Commands
  module Input
    #---------------------------------------------------------------------------
    #  Key map -> binary
    KEYS = {
      up: '224,72', down: '224,80', left: '224,75', right: '224,77', delete: '224,83',
      enter: '13', backspace: '8'
    }
    #---------------------------------------------------------------------------
    class << self
      #-------------------------------------------------------------------------
      #  reverse KEYS map
      #-------------------------------------------------------------------------
      def keys_binary
        Hash[KEYS.map(&:reverse)]
      end
      #-------------------------------------------------------------------------
      #  go up in history and select command
      #-------------------------------------------------------------------------
      def command_history_up(history, index)
        index = history.count if index.nil?
        return index = nil if (history.count - 1) < 0

        index -= 1 if index > 0
        # set output and flush console
        ret = history[index]
        Console.flush
        Console.pointer
        Console.echo(ret)
        # return output and index
        return ret, index
      end
      #-------------------------------------------------------------------------
      #  go down in history and select command
      #-------------------------------------------------------------------------
      def command_history_down(history, index)
        return unless index
        return if index >= (history.count - 1)

        index += 1 if index < history.count
        # set output and flush console
        ret = history[index]
        Console.flush
        Console.pointer
        Console.echo(ret)
        # return output and index
        return ret, index
      end
      #-------------------------------------------------------------------------
      #  move console cursor to the left
      #-------------------------------------------------------------------------
      def move_cursor_left(input, input_end)
        return input, input_end unless input && input.length > 0

        input_end = input[-1] + input_end
        input = input[0...-1]
        # move cursor
        $stdout.cursor_left(1)
        # return output
        return input, input_end
      end
      #-------------------------------------------------------------------------
      #  move console cursor to the right
      #-------------------------------------------------------------------------
      def move_cursor_right(input, input_end)
        return input, input_end unless input_end && input_end.length > 0

        input << input_end[0]
        input_end = input_end[1..-1]
        # move cursor
        $stdout.cursor_right(1)
        # return output
        return input, input_end
      end
      #-------------------------------------------------------------------------
      #  return currently typed string
      #-------------------------------------------------------------------------
      def return(input, input_end, history, index)
        output = input + input_end
        history << output unless output.empty?
        Console.echo_p

        return output
      end
      #-------------------------------------------------------------------------
      #  delete character in front of cursor
      #-------------------------------------------------------------------------
      def delete(input, input_end)
        input_end = input_end[1..-1]
        # flush console
        Console.flush
        Console.pointer
        Console.echo(input + input_end)
        $stdout.cursor_left(input_end.length)
        # return output
        return input_end
      end
      #-------------------------------------------------------------------------
      #  delete character behind cursor
      #-------------------------------------------------------------------------
      def backspace(input, input_end)
        input = input[0...-1]
        # flush console
        Console.flush(input_end.length > 0 ? 0 : 1)
        Console.pointer
        Console.echo(input + input_end)
        $stdout.cursor_left(input_end.length)
        # return output
        return input
      end
      #-------------------------------------------------------------------------
      #  write character from input to console
      #-------------------------------------------------------------------------
      def write(input, input_end, user_input)
        input << user_input
        Console.echo(user_input + input_end)
        # position cursor
        $stdout.cursor_left(input_end.length)
        # return output
        return input
      end
      #-------------------------------------------------------------------------
    end
    #---------------------------------------------------------------------------
  end
end
