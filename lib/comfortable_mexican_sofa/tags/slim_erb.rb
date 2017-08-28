require 'slim/erb_converter'

module ComfortableMexicanSofa::Tag::SlimErb
  class Generator < Temple::Generators::ERB
    def on_newline
      ''
    end
  end
  class Converter < Slim::Engine
    after :StaticMerger, Temple::Filters::CodeMerger
    replace :Generator, ComfortableMexicanSofa::Tag::SlimErb::Generator
  end
end
