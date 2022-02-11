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
      def argument(name = nil, description = nil, modifier = :required)
        attributes[:arguments] ||= {}
        attributes[:arguments][name] = [description, modifier]
      end
      #-------------------------------------------------------------------------
      #  set optional command options
      #-------------------------------------------------------------------------
      def option(name = nil, description = nil)
        attributes[:options] ||= {}
        attributes[:options][name] = description
      end
      #-------------------------------------------------------------------------
      #  set optional command flags
      #-------------------------------------------------------------------------
      def flag(name = nil, description = nil)
        attributes[:flags] ||= {}
        attributes[:flags][name] = description
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
      process_arguments(*args)

      process if Commands::Handler.validate(self, argument_count) && validate
    rescue
      Console.echo_p("Unable to run command `#{get(:name)}`:")
      Console.error
    end
    #---------------------------------------------------------------------------
    #  process input arguments and separate options from command arguments
    #---------------------------------------------------------------------------
    def process_arguments(*args)
      @arguments        = []
      @options          = []
      @option_arguments = {}
      @flags            = []
      key               = nil
      # go through each argument and categorize
      args.each do |arg|
        if arg.to_s.scan(/^--.*$/).count > 0
          @flags.push(arg[2..-1].downcase)
        elsif arg.to_s.scan(/^-.*$/).count > 0
          @options.push(arg[1..-1].downcase)
          key = arg[1..-1].downcase
        else
          if key
            @option_arguments[key] = arg
            key                    = nil
          else
            @arguments.push(arg)
          end
        end
      end
    end
    #---------------------------------------------------------------------------
    private
    #---------------------------------------------------------------------------
    #  check if option has been passed to command
    #---------------------------------------------------------------------------
    def option?(name)
      @options.include?(name.downcase)
    end
    #---------------------------------------------------------------------------
    #  check if flag has been passed to command
    #---------------------------------------------------------------------------
    def flag?(name)
      @flags.include?(name.downcase)
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
    def validate
      true
    end
    #---------------------------------------------------------------------------
    #  get command arguments
    #---------------------------------------------------------------------------
    def arguments
      @arguments ||= []
    end
    #---------------------------------------------------------------------------
    #  get option argument
    #---------------------------------------------------------------------------
    def option_argument(option)
      return nil unless option?(option.downcase)

      @option_arguments[option.downcase]
    end
    #---------------------------------------------------------------------------
    #  check first passed argument
    #---------------------------------------------------------------------------
    def argument?(argument)
      return false if !arguments || arguments.empty?

      arguments.first == argument
    end
    #---------------------------------------------------------------------------
    #  get number of entered arguments
    #---------------------------------------------------------------------------
    def argument_count
      @arguments.count + @option_arguments.keys.count
    end
    #---------------------------------------------------------------------------
  end
end
