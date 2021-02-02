require 'rails_helper'

RSpec.feature "AddRemoveAllLessonsInATopicToCurrentLessonPlan", type: :feature, js: true do
  context "lesson plan has no lessons" do
    let(:lesson_plan) { FactoryGirl.create(:lesson_plan) }
    let(:topic) { FactoryGirl.create(:topic_with_lessons) }
    let!(:lesson_1) { FactoryGirl.create(:lesson_1, topic: topic, level_id: 1) }
    let!(:lesson_2) { FactoryGirl.create(:lesson_2, topic: topic, level_id: 2) }

    before{ page.set_rack_session(lesson_plan_id: lesson_plan.id) }

    scenario "user adds all lessons in this topic to lesson plan" do
      visit topic_path(topic)

      expect(topic.lessons.count).to eq(2)
      expect(lesson_plan.lessons.count).to eq(0)
      expect(page).to have_content("Lesson Planner (0)")
      expect(page).to have_content("Add All Lessons To Lesson Plan")

      click_button("Add All Lessons To Lesson Plan")
      find_button("Remove All Lessons From Lesson Plan")

      expect(lesson_plan.lessons.count).to eq(2)
      expect(page).to have_content("Lesson Planner (2)")
    end
  end

  context "lesson plan contains lessons in a different topic" do
    let(:lesson_plan) { FactoryGirl.create(:lesson_plan_with_lesson) }
    let(:topic) { FactoryGirl.create(:topic_with_lessons) }
    let!(:lesson_1) { FactoryGirl.create(:lesson_1, topic: topic, level_id: 1) }
    let!(:lesson_2) { FactoryGirl.create(:lesson_2, topic: topic, level_id: 2) }

    before{ page.set_rack_session(lesson_plan_id: lesson_plan.id) }

    scenario "user adds all lessons in this topic to lesson plan" do
      visit topic_path(topic)

      expect(topic.lessons.count).to eq(2)
      expect(lesson_plan.lessons.count).to eq(1)
      expect(page).to have_content("Lesson Planner (1)")
      expect(page).to have_content("Add All Lessons To Lesson Plan")

      click_button("Add All Lessons To Lesson Plan")
      find_button("Remove All Lessons From Lesson Plan")

      expect(lesson_plan.lessons.count).to eq(3)
      expect(page).to have_content("Lesson Planner (3)")
    end
  end

  context "lesson plan already contains one of the lessons in this topic" do
    let(:lesson_plan) { FactoryGirl.create(:lesson_plan) }
    let(:topic) { FactoryGirl.create(:topic_with_lessons) }
    let!(:lesson_1) { FactoryGirl.create(:lesson_1, topic: topic, level_id: 1) }
    let!(:lesson_2) { FactoryGirl.create(:lesson_2, topic: topic, level_id: 2) }

    before{ page.set_rack_session(lesson_plan_id: lesson_plan.id) }

    scenario "user adds the other lesson in this topic to the lesson plan" do
      lesson_plan.lessons << lesson_1
      visit topic_path(topic)

      expect(topic.lessons.count).to eq(2)
      expect(lesson_plan.lessons.count).to eq(1)
      expect(page).to have_content("Lesson Planner (1)")
      expect(page).to have_content("Add All Lessons To Lesson Plan")

      click_button("Add All Lessons To Lesson Plan")
      find_button("Remove All Lessons From Lesson Plan")

      expect(lesson_plan.lessons.count).to eq(2)
      expect(page).to have_content("Lesson Planner (2)")
    end
  end

  context "lesson plan already contains all the lessons in this topic" do
    let(:lesson_plan) { FactoryGirl.create(:lesson_plan) }
    let(:topic) { FactoryGirl.create(:topic_with_lessons) }
    let!(:lesson_1) { FactoryGirl.create(:lesson_1, topic: topic, level_id: 1) }
    let!(:lesson_2) { FactoryGirl.create(:lesson_2, topic: topic, level_id: 2) }

    before{ page.set_rack_session(lesson_plan_id: lesson_plan.id) }

    scenario "user removes all lessons in this topic from the lesson plan" do
      lesson_plan.lessons << lesson_1
      lesson_plan.lessons << lesson_2
      visit topic_path(topic)

      expect(topic.lessons.count).to eq(2)
      expect(lesson_plan.lessons.count).to eq(2)
      expect(page).to have_content("Lesson Planner (2)")
      expect(page).to have_content("Remove All Lessons From Lesson Plan")

      click_button("Remove All Lessons From Lesson Plan")
      find_button("Add All Lessons To Lesson Plan")

      expect(lesson_plan.lessons.count).to eq(0)
      expect(page).to have_content("Lesson Planner (0)")
    end
  end

  context "lesson plan contains lessons in a different topic and one in this topic" do
    let(:lesson_plan) { FactoryGirl.create(:lesson_plan_with_lesson) }
    let(:topic) { FactoryGirl.create(:topic_with_lessons) }
    let!(:lesson_1) { FactoryGirl.create(:lesson_1, topic: topic, level_id: 1) }
    let!(:lesson_2) { FactoryGirl.create(:lesson_2, topic: topic, level_id: 2) }

    before{ page.set_rack_session(lesson_plan_id: lesson_plan.id) }

    scenario "user adds the remaining lesson in this topic to lesson plan" do
      lesson_plan.lessons << lesson_1
      visit topic_path(topic)

      expect(topic.lessons.count).to eq(2)
      expect(lesson_plan.lessons.count).to eq(2)
      expect(page).to have_content("Lesson Planner (2)")
      expect(page).to have_content("Add All Lessons To Lesson Plan")

      click_button("Add All Lessons To Lesson Plan")
      find_button("Remove All Lessons From Lesson Plan")

      expect(lesson_plan.lessons.count).to eq(3)
      expect(page).to have_content("Lesson Planner (3)")
    end
  end

  context "lesson plan contains lessons in a different topic and all lessons in this topic" do
    let(:lesson_plan) { FactoryGirl.create(:lesson_plan_with_lesson) }
    let(:topic) { FactoryGirl.create(:topic_with_lessons) }
    let!(:lesson_1) { FactoryGirl.create(:lesson_1, topic: topic, level_id: 1) }
    let!(:lesson_2) { FactoryGirl.create(:lesson_2, topic: topic, level_id: 2) }

    before{ page.set_rack_session(lesson_plan_id: lesson_plan.id) }

    scenario "user removes all lessons in this topic from lesson plan" do
      lesson_plan.lessons << lesson_1
      lesson_plan.lessons << lesson_2
      visit topic_path(topic)

      expect(topic.lessons.count).to eq(2)
      expect(lesson_plan.lessons.count).to eq(3)
      expect(page).to have_content("Lesson Planner (3)")
      expect(page).to have_content("Remove All Lessons From Lesson Plan")

      click_button("Remove All Lessons From Lesson Plan")
      find_button("Add All Lessons To Lesson Plan")

      expect(lesson_plan.lessons.count).to eq(1)
      expect(page).to have_content("Lesson Planner (1)")
    end
  end
end
