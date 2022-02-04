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
  #  Module to simplify OS detection
  #-----------------------------------------------------------------------------
  module OS
    #---------------------------------------------------------------------------
    #  check for OS versions
    def self.windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def self.mac?
      (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def self.unix?
      !OS.windows?
    end

    def self.linux?
      OS.unix? and !OS.mac?
    end

    def self.get
      ['windows', 'mac', 'unix', 'linux'].each do |try_os|
        return try_os.capitalize if send("#{try_os}?")
      end

      'Unknown'
    end
    #---------------------------------------------------------------------------
  end
end
