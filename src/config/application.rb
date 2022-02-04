#===============================================================================
#  Main console application configuration
#===============================================================================
module Env
  VERSION = '0.1.0'

  after_init do
    Rouge::Theme.find('base16').render(scope: '.highlight')
  end
end
