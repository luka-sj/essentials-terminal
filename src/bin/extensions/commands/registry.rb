#===============================================================================
#  Registry module for running commands
#===============================================================================
module Commands
  module Registry
    @@commands = {}
    #---------------------------------------------------------------------------
    #  register valid command
    #---------------------------------------------------------------------------
    def self.register(name, command)
      @@commands[name] = command
    end
    #---------------------------------------------------------------------------
    #  check if command has been registered
    #---------------------------------------------------------------------------
    def self.has_command?(command)
      @@commands.key?(command)
    end
    #---------------------------------------------------------------------------
    #  get command action from alias
    #---------------------------------------------------------------------------
    def self.from_alias(name)
      @@commands[name]
    end
    #---------------------------------------------------------------------------
  end
end