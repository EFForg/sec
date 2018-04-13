FactoryGirl.define do
  factory :lesson do
    body "lesson body"
    topic { |a| a.association :topic }
  end
end
