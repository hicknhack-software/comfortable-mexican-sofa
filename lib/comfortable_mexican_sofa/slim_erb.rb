require 'slim/erb_converter'

module SlimErb
  class Generator < Temple::Generators::ERB
    def on_newline
      ''
    end
  end
  class Converter < Slim::Engine
    after :StaticMerger, Temple::Filters::CodeMerger
    replace :Generator, SlimErb::Generator
  end
end
