class Material < ApplicationRecord
  has_many :uploads
  accepts_nested_attributes_for :uploads
end
