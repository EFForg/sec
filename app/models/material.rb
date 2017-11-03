class Material < ApplicationRecord
  has_many :uploads
  accepts_nested_attributes_for :uploads

  def first_file
    return if uploads.empty?
    uploads.first.file
  end
end
