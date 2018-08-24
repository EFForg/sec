require 'rails_helper'

RSpec.describe Article, type: :model do
  it_behaves_like 'previewable', { 'name' => 'New Name' }
end
