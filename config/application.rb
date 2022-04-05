#===============================================================================
#  Main console application configuration
#===============================================================================
module Env
  VERSION = '0.1.2'

  after_init do
    Rouge::Theme.find('base16').render(scope: '.highlight')
    # Windows compatibility
    Env.set_working_dir(ARGV.first) if ARGV.first && Env::OS.windows?
  end
end
