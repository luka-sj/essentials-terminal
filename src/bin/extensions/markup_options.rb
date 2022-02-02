#===============================================================================
#  Extension for console markup options
#===============================================================================
module Extensions
  module MarkupOptions
    #---------------------------------------------------------------------------
    private
    #---------------------------------------------------------------------------
    #  string colors
    #---------------------------------------------------------------------------
    def string_colors
      {
        default: '38', black: '30', red: '31', green: '32',
        brown: '33', blue: '34', purple: '35', cyan: '36',
        gray: '37', dark_gray: '1;30', light_red: '1;31',
        light_green: '1;32', yellow: '1;33', light_blue: '1;34',
        light_purple: '1;35', light_cyan: '1;36', white: '1;37'
      }
    end
    #---------------------------------------------------------------------------
    #  background colors
    #---------------------------------------------------------------------------
    def background_colors
      {
        default: '0', black: '40', red: '41', green: '42', brown: '43',
        blue: '44', purple: '45', cyan: '46', gray: '47', dark_gray: '100',
        light_red: '101', light_green: '102', yellow: '103', light_blue: '104',
        light_purple: '105', light_cyan: '106', white: '107'
      }
    end
    #---------------------------------------------------------------------------
    #  font options
    #---------------------------------------------------------------------------
    def font_options
      {
        bold: '1', dim: '2', italic: '3', underline: '4', reverse: '7',
        hidden: '8'
      }
    end
    #---------------------------------------------------------------------------
    #  syntax highlighting based on markup
    #---------------------------------------------------------------------------
    def markup_colors
      {
        '`' => :cyan, '"' => :light_purple, "'" => :light_purple, '$' => :green,
        '~' => :red
      }
    end
    #---------------------------------------------------------------------------
    #  syntax options based on markup
    #---------------------------------------------------------------------------
    def markup_options
      {
        '_' => :underline, '*' => :bold, '|' => :italic
      }
    end
    #---------------------------------------------------------------------------
    #  apply console coloring
    #---------------------------------------------------------------------------
    def markup_style(string, text: :default, bg: :default, **options)
      # get colors
      code_text = string_colors[text]
      code_bg   = background_colors[bg]
      # get options
      options_pool = options.select { |key, val| font_options.key?(key) && val }
      markup_pool  = options_pool.keys.map { |opt| font_options[opt] }.join(';').squeeze
      # return formatted string
      "\e[#{code_bg};#{markup_pool};#{code_text}m#{string}\e[0m".squeeze(';')
    end
    #---------------------------------------------------------------------------
  end
end
