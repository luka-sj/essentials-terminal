#===============================================================================
#  `String` class extensions
#===============================================================================
class ::String
  #-----------------------------------------------------------------------------
  #  turns string into an actual Ruby object
  #-----------------------------------------------------------------------------
  def constantize
    Object.const_get(self)
  end
  #-----------------------------------------------------------------------------
  #  capitalize first letter
  #-----------------------------------------------------------------------------
  def capitalize
    sub(/^\w/) { $&.upcase }
  end
  #-----------------------------------------------------------------------------
  #  checks if string is in URL format
  #-----------------------------------------------------------------------------
  def url?
    scan(/https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()!@:%_\+.~#?&\/\/=]*)/).count.positive?
  end
  #-----------------------------------------------------------------------------
  #  checks if string contains only numeric values
  #-----------------------------------------------------------------------------
  def numeric?
    scan(/^[+-]?([0-9]+)(?:\.[0-9]+)?$/).count > 1
  end
  #-----------------------------------------------------------------------------
end
