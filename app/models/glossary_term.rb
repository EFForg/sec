class GlossaryTerm < ApplicationRecord
  include FriendlyLocating

  validates :name,
            length: { minimum: 1 },
            uniqueness: true

  def synonyms_list=(list)
    self.synonyms = list.split(",").map(&:strip)
  end

  def synonyms_list
    synonyms.join(", ")
  end

  def names
    [name, *synonyms]
  end
end
