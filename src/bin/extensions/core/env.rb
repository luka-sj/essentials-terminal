#===============================================================================
#  Application environment module
#===============================================================================
module Env
  class << self
    #---------------------------------------------------------------------------
    #  get current working directory
    #---------------------------------------------------------------------------
    def working_dir
      @working_dir ||= Dir.pwd
    end
    #---------------------------------------------------------------------------
    #  set current working directory
    #---------------------------------------------------------------------------
    def set_working_dir(dir)
      @working_dir = dir
    end
    #---------------------------------------------------------------------------
    #  define Essentials script binding
    #---------------------------------------------------------------------------
    def essentials_binding
      @essentials_binding ||= Encapsulation.new
      @essentials_binding.get_binding
    end
    #---------------------------------------------------------------------------
    #  get Essentials version
    #  TODO: make this dynamic once the `essentials` command is live
    #---------------------------------------------------------------------------
    def essentials_version
      '19.1'
    end
    #---------------------------------------------------------------------------
    #  initialize Essentials scripts
    #---------------------------------------------------------------------------
    def load_essentials_scripts
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
    #---------------------------------------------------------------------------
    #  check if Essentials scripts have been loaded
    #---------------------------------------------------------------------------
    def essentials_loaded?
      @essentials_loaded ||= false
    end
    #---------------------------------------------------------------------------
    #  run code blocks at steps of initialization
    #---------------------------------------------------------------------------
    def before_init(&block)
      @run_before_init = block
    end

    def after_init(&block)
      @run_after_init = block
    end

    def run_before_init
      return unless @run_before_init

      @run_before_init.call
    end

    def run_after_init
      return unless @run_after_init

      @run_after_init.call
    end
    #---------------------------------------------------------------------------
  end
  #-----------------------------------------------------------------------------
  #  Module to simplify OS detection
  #-----------------------------------------------------------------------------
  module OS
    class << self
      #-------------------------------------------------------------------------
      #  check for OS versions
      def windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
      end

      def mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
      end

      def unix?
        !OS.windows?
      end

      def linux?
        OS.unix? and !OS.mac?
      end

      def get
        ['windows', 'mac', 'unix', 'linux'].each do |try_os|
          return try_os.capitalize if send("#{try_os}?")
        end

        'Unknown'
      end
      #-------------------------------------------------------------------------
    end
  end
  #-----------------------------------------------------------------------------
end
