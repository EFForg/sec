require 'rails_helper'

RSpec.describe Topic, type: :model do
  it_behaves_like 'previewable', { 'name' => 'New name' }
  it_behaves_like 'previewable with children',
    { 'admin_lessons_attributes' => {'1' => { 'id' => 'replace me',
                                              'objective' => 'edited' } } },
    Lesson, :admin_lessons, %w(duration pdf topic_id)
end
