class GlossaryTerm < ApplicationRecord
  include FriendlyLocating

  validates :name, length: { minimum: 1 }

  def names
    [name, *synonyms]
  end
end
