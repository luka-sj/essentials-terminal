#===============================================================================
#  Extension class to install and run required Ruby gems
#===============================================================================
module Core
  class Gemfile
    class << self
      #-------------------------------------------------------------------------
      #  register gem as dependency
      #-------------------------------------------------------------------------
      def gem(name, gem_alias = nil)
        gem_alias ||= name
        gems.push([name, gem_alias])
      end
      #-------------------------------------------------------------------------
      #  list all gem dependencies
      #-------------------------------------------------------------------------
      def gems
        @gems ||= []
      end
      #-------------------------------------------------------------------------
      #  install all required gems
      #-------------------------------------------------------------------------
      def install
        # initial output
        Console.echo_p('Checking `Gemfile` for dependencies ...', 2)
        failed = false
        # iterate through all registered gems
        gems.each do |gem|
          # check if gem already installed on system
          if Console.run("gem list -i #{gem.first} > nul")
            Console.echo_li("gem `#{gem.first}` already installed.\r\n")
            next
          end

          # install gem if required
          Console.echo_li("installing gem `#{gem.first}`...")
          status = Console.run("gem install #{gem.first} > nul")
          failed = true unless status
          # return status and delete gem from registry if install failed
          gems.delete(gem.first) if failed
          Console.echo_status(status)
        end
        # print output to console
        Console.echo_p
        if failed
          Console.echo_p('Some gems failed to install. See output above for more details.', 2)
        else
          Console.echo_p('All gem dependencies have been satisfied.', 2)
        end
      end
      #-------------------------------------------------------------------------
    end
  end
end
