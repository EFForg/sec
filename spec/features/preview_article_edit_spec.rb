require 'rails_helper'

RSpec.feature "Preview Changes", type: :feature, js: true do
  let(:admin){ FactoryGirl.create(:admin_user) }
  before { login(admin) }

  scenario "admin can preview articles" do
    article = FactoryGirl.create(:article)
    new_name = "Edited name"
    visit edit_admin_article_path(article)
    fill_in "Name", with: new_name

    switch_to_window window_opened_by { click_on 'Preview' }
    sleep 0.1

    expect(page).to have_content("PREVIEW WARNING")
    expect(page).to have_content(new_name)
  end

  scenario "admin can preview topics & lessons" do
    lesson = FactoryGirl.create(:lesson)
    new_name = "Edited name"
    new_ratio = "1:4"
    visit edit_admin_topic_path(lesson.topic)
    fill_in "Name", with: new_name
    fill_in "Instructor students ratio", with: new_ratio

    switch_to_window window_opened_by { click_on 'Preview' }
    sleep 0.1

    expect(page).to have_content("PREVIEW WARNING")
    expect(page).to have_content(new_name)
    expect(page).to have_content(new_ratio)
  end

  scenario "admin can publish changes from preview page" do
    lesson = FactoryGirl.create(:lesson)
    new_name = "Edited name"
    new_ratio = "1:4"
    visit edit_admin_topic_path(lesson.topic)
    fill_in "Name", with: new_name
    fill_in "Instructor students ratio", with: new_ratio

    switch_to_window window_opened_by { click_on 'Preview' }
    sleep 0.1

    accept_alert { click_on "Publish changes", match: :first }
    visit topic_path(lesson.topic)

    expect(page).to have_content(new_name)
    expect(page).to have_content(new_ratio)
  end
end
