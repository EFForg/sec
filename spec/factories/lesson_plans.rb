FactoryGirl.define do
  factory :lesson_plan do
    lessons_count 0

    factory :lesson_plan_with_lesson do
      after(:create) do |plan|
        lesson = FactoryGirl.create(:lesson)
        plan.lessons << lesson
      end
    end

  end
end
