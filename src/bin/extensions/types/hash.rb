#===============================================================================
#  `Hash` class extensions
#===============================================================================
class ::Hash
  #-----------------------------------------------------------------------------
  #  perform deep merge (returns Hash)
  #-----------------------------------------------------------------------------
  def deep_merge(hash)
    merged_hash = clone
    merged_hash.deep_merge!(hash) if hash.is_a?(Hash)
    merged_hash
  end
  #-----------------------------------------------------------------------------
  #  perform deep merge (destructive)
  #-----------------------------------------------------------------------------
  def deep_merge!(hash)
    return unless hash.is_a?(Hash)

    hash.each do |key, val|
      if self[key].is_a?(Hash)
        self[key].deep_merge!(val)
      else
        self[key] = val
      end
    end
  end
  #-----------------------------------------------------------------------------
end
