#===============================================================================
#  Extension for text markup
#===============================================================================
module Extensions
  module Markup
    #---------------------------------------------------------------------------
    private
    #---------------------------------------------------------------------------
    #  full hash of markup options
    #---------------------------------------------------------------------------
    def markup_all_options
      @markup_all_options ||= markup_colors.merge(markup_options)
    end
    #---------------------------------------------------------------------------
    #  component level markup
    #---------------------------------------------------------------------------
    def markup_component(string, component, key, options)
      # trim inner markup content
      l = key.length
      trimmed = component[l...-l]
      # merge markup options
      options[trimmed] = {} unless options[trimmed]
      options[trimmed].deep_merge!({}.tap do |new_opt|
        new_opt[:text] = markup_colors[key] if markup_colors.key?(key)
        new_opt[markup_options[key]] = true if markup_options.key?(key)
      end)
      # remove markup from input string
      string.gsub!(component, trimmed)
      # return output
      return string, options
    end
    #---------------------------------------------------------------------------
    #  deconstruct markup values for given string
    #---------------------------------------------------------------------------
    def markup_breakdown(string, options = {})
      # iterate through all options
      markup_all_options.each_key do |key|
        # ensure escape
        key_char = key.chars.map { |c| "\\#{c}" }.join
        # define regex
        regex = "#{key_char}.*?#{key_char}"
        # go through matches
        string.scan(/#{regex}/).each do |component|
          return *markup_breakdown(*markup_component(string, component, key, options))
        end
      end
      # return output
      return string, options
    end
    #---------------------------------------------------------------------------
    #  apply markup for string
    #---------------------------------------------------------------------------
    def markup(string)
      # get a breakdown of all markup options
      string, options = markup_breakdown(string)
      # iterate through each option and apply
      options.each do |key, opt|
        string.gsub!(key, markup_style(key, **opt))
      end
      # return string
      return string
    end
    #---------------------------------------------------------------------------
  end
end
