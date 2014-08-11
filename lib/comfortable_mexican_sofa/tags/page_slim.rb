require 'slim/erb_converter'

class ComfortableMexicanSofa::Tag::PageSlim
  include ComfortableMexicanSofa::Tag

  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:page:(#{identifier}):slim\s*\}\}/
  end

  def content
    block.content
  end

  def render
    processed = ComfortableMexicanSofa::Tag.process_content_with_indention(blockable, content.to_s, self)
    if parent && [ComfortableMexicanSofa::Tag::PageSlim,ComfortableMexicanSofa::Tag::SnippetSlim].include?(parent.class)
      processed
    else
      Slim::ERBConverter.new(file: identifier.to_s).call(processed)
    end
  end
end
