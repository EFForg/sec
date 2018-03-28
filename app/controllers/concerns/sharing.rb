module Sharing
  extend ActiveSupport::Concern

  protected

  def og_object(object, name: nil, description: nil)
    @og_title = name || object.name
    @og_description = description || helpers.preview(object, allowed_tags: [])
  end
end
