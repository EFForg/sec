class GlossaryTerm < ApplicationRecord
  include FriendlyLocating

  validates :name,
            length: { minimum: 1 },
            uniqueness: true

  def names
    [name, *synonyms]
  end
end
