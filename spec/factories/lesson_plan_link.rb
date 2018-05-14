FactoryGirl.define do
  factory :lesson_plan_link do
    key "correct-horse-battery-staple"

    after(:create) do |link|
      link.update_attribute(:lesson_ids, create_list(:lesson, 2).pluck(:id))
    end

    factory :used_lesson_plan_link do
      after(:create) do |link|
        link.update_attribute(:lesson_plan, FactoryGirl.create(:lesson_plan))
        link.lesson_plan.lesson_ids = link.lesson_ids
      end
    end
  end
end
