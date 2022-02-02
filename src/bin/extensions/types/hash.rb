#===============================================================================
#  `hash` class extensions
#===============================================================================
class ::Hash
  #-----------------------------------------------------------------------------
  #  perform deep merge (returns Hash)
  #-----------------------------------------------------------------------------
  def deep_merge(hash)
    merged_hash = self.clone
    merged_hash.deep_merge!(hash) if hash.is_a?(Hash)
    return merged_hash
  end
  #-----------------------------------------------------------------------------
  #  perform deep merge (destructive)
  #-----------------------------------------------------------------------------
  def deep_merge!(hash)
    # failsafe
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
