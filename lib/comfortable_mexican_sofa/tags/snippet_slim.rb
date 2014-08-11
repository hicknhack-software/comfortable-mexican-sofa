require 'slim/erb_converter'

class ComfortableMexicanSofa::Tag::SnippetSlim
  include ComfortableMexicanSofa::Tag

  def self.regex_tag_signature(identifier = nil)
    identifier ||= /[\w\-]+/
    /\{\{\s*cms:snippet:(#{identifier}):slim\s*\}\}/
  end

  # Find or initialize Comfy::Cms::Snippet object
  def snippet
    blockable.site.snippets.detect{|s| s.identifier == self.identifier.to_s} ||
        blockable.site.snippets.build(:identifier => self.identifier.to_s)
  end

  def content
    snippet.content
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
