require 'haml'

module Haml2ErbHelper
  @@_hamlout = Haml::Buffer.new(nil, Haml::Engine.new('').send(:options_for_buffer))
  ActionView::Base::CompiledTemplates.send(:include, self)
end
