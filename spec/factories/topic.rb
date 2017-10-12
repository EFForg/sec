FactoryGirl.define do
  factory :topic do
    name "A topic"

    after(:create) do |topic|
      FactoryGirl.create(:lesson, topic_id: topic.id)
    end

    published_at Time.now
  end

  factory :lesson do
    published_at Time.now
  end
end
