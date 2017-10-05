class PromotedContent < ApplicationRecord
  self.table_name = "promoted_content"

  belongs_to :content, polymorphic: true

  def content_id_string
    if content.present?
      "#{content.name} (##{content.id})"
    end
  end

  def content_id_string=(str)
    self.content_id = str.scan(/#(\d+)/)[-1].try(:last)
  end
end
