FactoryGirl.define do
  factory :topic do
    name "A topic"
    published true

    factory :topic_with_lessons do
      name "Another topic"
      description "Any old description to make sure we land on the Intro tab"
    end
  end
end
