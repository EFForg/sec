module Publishable
  extend ActiveSupport::Concern

  def protect_unpublished!(resource)
    return if current_admin_user
    raise ActiveRecord::RecordNotFound if resource.unpublished?
  end
end
