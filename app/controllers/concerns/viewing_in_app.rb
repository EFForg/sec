module ViewingInApp
  extend ActiveSupport::Concern

  def self.included(base)
    base.send(:action_item, :view, only: :edit) do
      link_to "View", resource
    end
  end
end
