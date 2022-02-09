#===============================================================================
#  Base command template class
#===============================================================================
module Commands
  class BaseCommand
    class << self
      #-------------------------------------------------------------------------
      #  collection of all attribute metadata
      #-------------------------------------------------------------------------
      def attributes
        @attributes ||= {}
      end
      #-------------------------------------------------------------------------
      #  set command name
      #-------------------------------------------------------------------------
      def name(name = nil)
        attributes[:name] = name
      end
      #-------------------------------------------------------------------------
      #  set command description
      #-------------------------------------------------------------------------
      def description(description = nil)
        attributes[:description] = description
      end
      #-------------------------------------------------------------------------
      #  set command aliases
      #-------------------------------------------------------------------------
      def aliases(*names)
        attributes[:alias] = names
      end
      #-------------------------------------------------------------------------
      #  set required command arguments
      #-------------------------------------------------------------------------
      def option(name = nil, description = nil, modifier = :required)
        attributes[:options] ||= {}
        attributes[:options][name] = [description, modifier]
      end
      #-------------------------------------------------------------------------
      #  set optional command flags
      #-------------------------------------------------------------------------
      def flag(name = nil, description = nil)
        attributes[:flag] ||= {}
        attributes[:flag][name] = description
      end
      #-------------------------------------------------------------------------
      #  set command version
      #-------------------------------------------------------------------------
      def version(version = nil)
        attributes[:version] = version
      end
      #-------------------------------------------------------------------------
      #  register command in main Commands::Registry
      #-------------------------------------------------------------------------
      def register
        return unless attributes[:name]

        Commands::Registry.register(attributes[:name], attributes[:name])

        return unless attributes[:alias]

        attributes[:alias].each do |name|
          Commands::Registry.register(name, attributes[:name])
        end
      end
    end
    #---------------------------------------------------------------------------
    #  get specified metadata attribute
    #---------------------------------------------------------------------------
    def get(attribute)
      attributes[attribute]
    end
    #---------------------------------------------------------------------------
    #  run command
    #---------------------------------------------------------------------------
    def run(*args)
      process_options(*args)

      process if Commands::Handler.validate(self, *@options) && validate
    rescue
      Console.echo_p("Unable to run command `#{get(:name)}`:")
      Console.error
    end
    #---------------------------------------------------------------------------
    #  process input arguments and separate flags from command arguments
    #---------------------------------------------------------------------------
    def process_options(*args)
      @options = []
      @flags = []
      # go through each argument and categorize
      args.each do |arg|
        if arg.to_s.scan(/^-.*$/).count > 0
          @flags.push(arg[1..-1].downcase)
        else
          @options.push(arg)
        end
      end
    end
    #---------------------------------------------------------------------------
    private
    #---------------------------------------------------------------------------
    #  check if flag has been passed to command
    #---------------------------------------------------------------------------
    def flag?(name)
      @flags.include?(name)
    end
    #---------------------------------------------------------------------------
    #  get class metadata attributes
    #---------------------------------------------------------------------------
    def attributes
      self.class.attributes
    end
    #---------------------------------------------------------------------------
    # private validation method
    #---------------------------------------------------------------------------
    def validate(*_args)
      true
    end
    #---------------------------------------------------------------------------
    #  get command options
    #---------------------------------------------------------------------------
    def options
      @options ||= []
    end
    #---------------------------------------------------------------------------
    #  check first passed option
    #---------------------------------------------------------------------------
    def option?(option)
      return false if !options || options.empty?

      options.first == option
    end
    #---------------------------------------------------------------------------
  end
end
