module Tagging
  extend ActiveSupport::Concern

  included do
    before_action :find_tags, only: :index
  end

  protected

  def find_tags
    @tags = ActsAsTaggableOn::Tag.joins(:taggings).
      where(taggings: { taggable_type: taggable_type.name }).
      distinct.to_a

    if tag = @tags.find{ |t| t.name == params[:tag] }
      @tags = [tag] + @tags.delete_if{ |t| t.name == params[:tag] }
    end
  end
end
