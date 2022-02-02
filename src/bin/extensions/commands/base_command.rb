#===============================================================================
#  Base command template class
#===============================================================================
module Commands
  class BaseCommand
    #---------------------------------------------------------------------------
    #  collection of all attribute metadata
    #---------------------------------------------------------------------------
    def self.attributes
      @attributes ||= {}
    end
    #---------------------------------------------------------------------------
    #  set command name
    #---------------------------------------------------------------------------
    def self.name(name)
      attributes[:name] = name
    end
    #---------------------------------------------------------------------------
    #  set command description
    #---------------------------------------------------------------------------
    def self.description(description)
      attributes[:description] = description
    end
    #---------------------------------------------------------------------------
    #  set command aliases
    #---------------------------------------------------------------------------
    def self.aliases(*names)
      attributes[:alias] = names
    end
    #---------------------------------------------------------------------------
    #  set required command arguments
    #---------------------------------------------------------------------------
    def self.option(name, description = nil)
      attributes[:options] = {} unless attributes[:options]
      attributes[:options][name] = description
    end
    #---------------------------------------------------------------------------
    #  set optional command flags
    #---------------------------------------------------------------------------
    def self.flag(name, description = nil)
      attributes[:flag] = {} unless attributes[:flag]
      attributes[:flag][name] = description
    end
    #---------------------------------------------------------------------------
    #  set command version
    #---------------------------------------------------------------------------
    def self.version(version)
      attributes[:version] = version
    end
    #---------------------------------------------------------------------------
    #  register command in main Commands::Registry
    #---------------------------------------------------------------------------
    def self.register
      return unless attributes[:name]
      Commands::Registry.register(attributes[:name], attributes[:name])

      return unless attributes[:alias]

      attributes[:alias].each do |name|
        Commands::Registry.register(name, attributes[:name])
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

      process(*options) if Commands::Handler.validate(self, *options)
    end
    #---------------------------------------------------------------------------
    #  process input arguments and separate flags from command arguments
    #---------------------------------------------------------------------------
    def process_flags(*args)
      parsed = []
      @flags = []
      # go through each argument and categorize
      args.each do |arg|
        if arg.scan(/^-.*$/).count > 0
          @flags.push(arg[1..-1])
        else
          parsed.push(arg)
        end
      end
      # return only command arguments
      return parsed
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
    #---------------------------------------------------------------------------
  end
end
