require 'asciidoctor'

class ComfortableMexicanSofa::Tag::PageAsciidoc
  include ComfortableMexicanSofa::Tag

  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:page:(#{identifier}):asciidoc\s*\}\}/
  end

  def content
    block.content
  end

  def render
    Asciidoctor.convert content.to_s, safe: 'safe'
  end
end
