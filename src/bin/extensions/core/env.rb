#===============================================================================
#  Application environment module
#===============================================================================
module Env
  #-----------------------------------------------------------------------------
  #  get current working directory
  #-----------------------------------------------------------------------------
  def self.working_dir
    @working_dir ||= Dir.pwd
  end
  #-----------------------------------------------------------------------------
  #  set current working directory
  #-----------------------------------------------------------------------------
  def self.set_working_dir(dir)
    @working_dir = dir
  end
  #-----------------------------------------------------------------------------
  #  define Essentials script binding
  #-----------------------------------------------------------------------------
  def self.essentials_binding
    @essentials_binding ||= Encapsulation.new
    @essentials_binding.get_binding
  end
  #-----------------------------------------------------------------------------
  #  get Essentials version
  #  TODO: make this dynamic once the `essentials` command is live
  #-----------------------------------------------------------------------------
  def self.essentials_version
    '19.1'
  end
  #-----------------------------------------------------------------------------
  #  initialize Essentials scripts
  #-----------------------------------------------------------------------------
  def self.load_essentials_scripts
    return false unless File.safe?("#{Env.working_dir}/Data/Scripts.rxdata")

    Dir.change_to_working
    scripts = File.open(rxdata, 'rb') { |f| Marshal.load(f) }
    scripts.each do |collection|
      _, title, script = collection
      script = Zlib::Inflate.inflate(script).delete("\r").gsub("\t", '  ')

      next if script.empty? || title.downcase == 'main'

      # TODO: incomplete - needs to add functionality to initialize game
      # components and eval runtime values
      eval(script, Env.essentials_binding)
    end

    Dir.restore
    @essentials_loaded = true
  end
  #-----------------------------------------------------------------------------
  #  check if Essentials scripts have been loaded
  #-----------------------------------------------------------------------------
  def self.essentials_loaded?
    @essentials_loaded ||= false
  end
  #-----------------------------------------------------------------------------
end
