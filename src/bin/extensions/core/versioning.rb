#===============================================================================
#  Helper module for softvare versioning
#===============================================================================
module Extensions
  #-----------------------------------------------------------------------------
  module Versioning
    class << self
      #-------------------------------------------------------------------------
      #  converts versioning string to numeric output
      #-------------------------------------------------------------------------
      def to_i(string)
        versionable = string.split('.')
        (3 - versionable.count).times { versionable << '0' }

        versionable.map { |v| v.rjust(5, '0') }.join('').to_i
      end
      #-------------------------------------------------------------------------
      #  compares first number lower than second and returns markup
      #-------------------------------------------------------------------------
      def comparative_markup(lower_version, higher_version, markup = '!')
        to_i(lower_version) < to_i(higher_version) ? markup : nil
      end
      #-------------------------------------------------------------------------
    end
  end
  #-----------------------------------------------------------------------------
end
