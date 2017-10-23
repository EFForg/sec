FactoryGirl.define do
  factory :lesson_plan do
    lessons_count 0

    factory :lesson_plan_with_lesson do
      after(:create) do |plan|
        topic = FactoryGirl.create(:topic)
        plan.lessons << topic.lessons.first
      end
    end

  end
end
