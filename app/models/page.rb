class Page < ApplicationRecord
  has_many :managed_content
  delegate :region, to: :managed_content

  def body_alias
    if name.include? "overview"
      "Intro"
    else
      "Body"
    end
  end
end

