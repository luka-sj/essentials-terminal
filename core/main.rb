#-------------------------------------------------------------------------------
#  load system level scripts first
#-------------------------------------------------------------------------------
Dir[
  'core/extensions/**/*.rb',
  'core/console/**/*.rb',
  'config/**/*.rb'
].each { |f| require "./#{f}" }.each { |f| Env::CORE_DIRECTORIES << f }
#-------------------------------------------------------------------------------
#  initial console output
#-------------------------------------------------------------------------------
Console.setup
#-------------------------------------------------------------------------------
#  install required gems
#-------------------------------------------------------------------------------
class Core::Gemfile
  install
  load
end

Env.run_before_init
#-------------------------------------------------------------------------------
#  load required directories and files on start
#-------------------------------------------------------------------------------
Dir[
  'lib/**/*.rb',
  'app/**/*.rb'
].each { |f| require "./#{f}" }.each { |f| Env::APP_DIRECTORIES << f }
#-------------------------------------------------------------------------------
#  start application
#-------------------------------------------------------------------------------
Env.run_after_init
Application.start
