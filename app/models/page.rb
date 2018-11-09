class Page < ApplicationRecord
  include FriendlyLocating
  include ActivePreview::Previewing
end
