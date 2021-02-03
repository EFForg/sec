FactoryGirl.define do
  factory :lesson do
    body "lesson body"
    topic { |a| a.association :topic }

    factory :lesson_1 do
      body "lesson body 1"
    end

    factory :lesson_2 do
      body "lesson body 2"
    end

  end
end
