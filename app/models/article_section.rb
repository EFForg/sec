class ArticleSection < ApplicationRecord
  include Previewing

  has_many :articles, ->{ order(:section_position) },
    foreign_key: "section_id", dependent: :nullify

  validates :name, uniqueness: true

  accepts_nested_attributes_for :articles
end
