class Comfy::Cms::Snippet < ActiveRecord::Base
  self.table_name = 'comfy_cms_snippets'
  
  cms_is_categorized
  cms_is_mirrored
  cms_has_revisions_for :content
  
  # -- Relationships --------------------------------------------------------
  belongs_to :site
  
  # -- Callbacks ------------------------------------------------------------
  before_validation :assign_label
  after_validation :compile_content
  before_create :assign_position
  after_save    :clear_page_content_cache
  after_destroy :clear_page_content_cache
  
  # -- Validations ----------------------------------------------------------
  validates :site_id,
    :presence   => true
  validates :label,
    :presence   => true
  validates :identifier,
    :presence   => true,
    :uniqueness => { :scope => :site_id },
    :format     => { :with => /\A\w[a-z0-9_-]*\z/i }
    
  # -- Scopes ---------------------------------------------------------------
  default_scope -> { order('comfy_cms_snippets.position') }

  def editor_mime_type
    if ComfortableMexicanSofa.config.allow_irb
      if content and content.include?('‹%')
        'application/x-erb'
      else
        'application/x-slim'
      end
    else
      'text/html'
    end
  end

protected

  def compile_content
    if 'application/x-slim' == editor_mime_type
      require 'slim/erb_converter'
      Slim::ERBConverter.new(file: label).call(content.gsub(/\{\{.*?\}\}/, 'test') )
    end
  end
  
  def assign_label
    self.label = self.label.blank?? self.identifier.try(:titleize) : self.label
  end
  
  def clear_page_content_cache
    Comfy::Cms::Page.where(:id => site.pages.pluck(:id)).update_all(:content_cache => nil)
  end
  
  def assign_position
    max = self.site.snippets.maximum(:position)
    self.position = max ? max + 1 : 0
  end
  
end
