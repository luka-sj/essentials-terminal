#-------------------------------------------------------------------------------
#  load system level scripts first
#-------------------------------------------------------------------------------
Dir[
  'src/bin/extensions/**/*.rb',
  'src/bin/console/**/*.rb',
  'src/config/**/*.rb'
].each { |f| require "./#{f}" }
#-------------------------------------------------------------------------------
#  initial console output
#-------------------------------------------------------------------------------
Console.setup
#-------------------------------------------------------------------------------
#  install required gems
#-------------------------------------------------------------------------------
class Core::Gemfile
  install
end

Core::Gemfile.gems.each do |gem|
  require gem
rescue LoadError
  Console.echo_p("Gem error: unable to load gem !#{gem}!.")
end
#-------------------------------------------------------------------------------
#  load required directories and files on start
#-------------------------------------------------------------------------------
Dir[
  'src/lib/**/*.rb',
  'src/app/**/*.rb'
].each { |f| require "./#{f}" }
#-------------------------------------------------------------------------------
#  start console loop
#-------------------------------------------------------------------------------
Rouge::Theme.find('base16').render(scope: '.highlight')

loop do
  Console.await
end
