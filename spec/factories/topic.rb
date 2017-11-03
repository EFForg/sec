FactoryGirl.define do
  factory :topic do
    name "A topic"

    after(:create) do |topic|
      FactoryGirl.create(:lesson, topic_id: topic.id)
      topic.lessons.reload
    end

    published true
  end

  factory :lesson do
    body "lesson body"
  end
end
