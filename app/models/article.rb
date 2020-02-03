class Article < ApplicationRecord
  include FriendlyLocating

  include Publishing
  include Featuring
  include ActivePreview::Previewing

  acts_as_taggable

  include PgSearch
  multisearchable against: %i(name body tag_list), if: :published?

  belongs_to :section, class_name: "ArticleSection", optional: true

  belongs_to :next_article, class_name: "Article", optional: true

  mount_uploader :pdf, PdfUploader
  after_save :enqueue_pdf_update,
    if: ->{ published? && !saved_changes.key?(:pdf) }

  def enqueue_pdf_update
    UpdateArticlePdf.perform_later(id)
  end

  def pdf_filename
    "#{name}.pdf"
  end
end
