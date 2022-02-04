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
      def name(name)
        attributes[:name] = name
      end
      #-------------------------------------------------------------------------
      #  set command description
      #-------------------------------------------------------------------------
      def description(description)
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
      def option(name, description = nil, modifier = :required)
        attributes[:options] ||= {}
        attributes[:options][name] = [description, modifier]
      end
      #-------------------------------------------------------------------------
      #  set optional command flags
      #-------------------------------------------------------------------------
      def flag(name, description = nil)
        attributes[:flag] ||= {}
        attributes[:flag][name] = description
      end
      #-------------------------------------------------------------------------
      #  set command version
      #-------------------------------------------------------------------------
      def version(version)
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
      options = process_flags(*args)

      process(*options) if Commands::Handler.validate(self, *options) && validate(*options)
    rescue StandardError
      Console.echo_p("Unable to run command `#{self.class.name}`:")
      Console.echo_p($ERROR_INFO.message)
    end
    #---------------------------------------------------------------------------
    #  process input arguments and separate flags from command arguments
    #---------------------------------------------------------------------------
    def process_flags(*args)
      parsed = []
      @flags = []
      # go through each argument and categorize
      args.each do |arg|
        if arg.to_s.scan(/^-.*$/).count > 0
          @flags.push(arg[1..-1])
        else
          parsed.push(arg)
        end
      end
      # return only command arguments
      parsed
    end
    #---------------------------------------------------------------------------
    #  check if flag has been passed to command
    #---------------------------------------------------------------------------
    def flag?(name)
      @flags.include?(name)
    end
    #---------------------------------------------------------------------------
    private
    #  get class metadata attributes
    def attributes
      self.class.attributes
    end
    # private validation method
    def validate(*args)
      true
    end
    #---------------------------------------------------------------------------
  end
end
