# frozen_string_literal: true

# Tag for reusable snippets within context's site scope. Looks like this:
#   {{cms:snippet identifier}}
# Snippets may have more tags in them like fragments, so they may be expanded too.
#
class ComfortableMexicanSofa::Content::Tag::Snippet < ComfortableMexicanSofa::Content::Tag

  attr_reader :identifier

  def initialize(context:, params: [], source: nil)
    super
    @identifier = params[0]
    @options    = params.extract_options!

    @markup = @options["markup"]

    unless @identifier.present?
      raise Error, "Missing identifier for snippet tag"
    end
  end

  def content
    snippet.content
  end

  # Grabbing or initializing Comfy::Cms::Snippet object
  def snippet
    context.site.snippets.detect { |s| s.identifier == identifier } ||
      context.site.snippets.build(identifier: identifier)
  end

  def render
    case @markup
    when "slim"
      SlimErb::Converter.new(file: identifier.to_s, disable_capture: true).call(content.to_s)
    when "markdown"
      Kramdown::Document.new(self.content.to_s).to_html
    else
      content.to_s
    end
  end 
end

ComfortableMexicanSofa::Content::Renderer.register_tag(
  :snippet, ComfortableMexicanSofa::Content::Tag::Snippet
)
