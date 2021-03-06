#===============================================================================
#  Application environment module
#===============================================================================
module Env
  CORE_DIRECTORIES ||= []
  APP_DIRECTORIES  ||= []

  class << self
    attr_accessor :initial_directory, :essentials_binding
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
      Dir.chdir(dir)
    end
    #---------------------------------------------------------------------------
    #  sync current working directory
    #---------------------------------------------------------------------------
    def sync_working_dir
      Dir.chdir(working_dir)
    end
    #---------------------------------------------------------------------------
    #  check if in Essentials directory
    #---------------------------------------------------------------------------
    def essentials_dir?
      File.exist?("#{working_dir}/Game.rxproj") && File.exist?("#{working_dir}/Data/Scripts.rxdata")
    end
    #---------------------------------------------------------------------------
    #  get Essentials version
    #  TODO: make this dynamic once the `essentials` command is live
    #---------------------------------------------------------------------------
    def essentials_version
      '19.1'
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
      @initial_directory ||= Dir.pwd

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
        ['windows', 'mac', 'linux', 'unix'].each do |try_os|
          return try_os.capitalize if send("#{try_os}?")
        end

        'Unknown'
      end
      #-------------------------------------------------------------------------
    end
  end
  #-----------------------------------------------------------------------------
end
