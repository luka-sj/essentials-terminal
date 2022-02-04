#===============================================================================
#  Main console application configuration
#===============================================================================
module Env
  VERSION = '0.1.0'

  after_init do
    Rouge::Theme.find('base16').render(scope: '.highlight')
    Env.set_working_dir(ARGV[0]) if ARGV[0] # Windows compatibility
  end
end
