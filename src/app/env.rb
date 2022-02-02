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
  #  get Essentials version
  #  TODO: make this dynamic once the `essentials` command is live
  #-----------------------------------------------------------------------------
  def self.essentials_version
    '19.1'
  end
  #-----------------------------------------------------------------------------
end
