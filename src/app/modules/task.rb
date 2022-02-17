#===============================================================================
#  Module for handling task definitions
#===============================================================================
module Commands
  module Task
    class << self
      #-------------------------------------------------------------------------
      #  define new task
      #-------------------------------------------------------------------------
      def new(name, &block)
        stored_tasks[name.to_s] = block
      end
      #-------------------------------------------------------------------------
      private
      #-------------------------------------------------------------------------
      #  get collection of all stored tasks
      #-------------------------------------------------------------------------
      def stored_tasks
        @stored_tasks ||= {}
      end
      #-------------------------------------------------------------------------
      #  run specified task
      #-------------------------------------------------------------------------
      def run(name)
        unless stored_tasks.key?(name)
          Console.echo_p("Unable to run task: could not find any matching task of name !:#{name}!.")
          return nil
        end

        Console.echo_p("Running task `#{name}` ...")
        stored_tasks[name].call
        Console.echo_p("$Successfully$ completed task `#{name}`.")
      rescue
        Console.echo_p("Failed to execute task !:#{name}!:")
        Console.error
      end
      #-------------------------------------------------------------------------
    end
  end
end
