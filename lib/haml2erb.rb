require 'haml'

module Haml
  class Engine
    attr_reader :precompiled
  end
  
  class Erb < Engine
    def flush_merged_text
      return if @merged_text.empty?
      
      @precompiled << @merged_text
      
      @merged_text = ''
      @dont_tab_up_next_text = false
      @tab_change = 0
    end
    
    def push_script(*args)
      flush_merged_text
      text = args[0]
      @precompiled << "<%=#{text} %>"
    end
    
    @@case_opened = false
    
    def push_silent(text, can_suppress = false)
      flush_merged_text
      if text =~ /_hamlout\.open_tag/
        @precompiled << "<%#{text.sub('_hamlout', '@@_hamlout')};%><%= @@_hamlout.buffer %><% @@_hamlout.buffer = '' %>"
      elsif text =~ /case/
        @precompiled << "<%#{text}"
        @@case_opened = true
      elsif text =~ /when/ && @@case_opened
        @precompiled << "#{text} %>"
        @@case_opened = false
      else
        @precompiled << "<%#{text} %>"
      end
    end
  end
end

class Haml2Erb
  def self.convert(filename)
    Haml::Erb.new(File.open(filename, 'r').send(:read)).precompiled
  end
end
