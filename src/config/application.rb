#===============================================================================
#  Main console application configuration
#===============================================================================
module Env
  VERSION = '0.1.0'

  after_init do
    Rouge::Theme.find('base16').render(scope: '.highlight')
    if ARGV.first && Env::OS.windows? # Windows compatibility
      Env.set_working_dir(ARGV.first)
      Dir.chdir(ARGV.first)
    end
  end
end
