require 'rails_helper'

RSpec.feature "Preview Article Changes", type: :feature, js: true do
  let(:admin){ FactoryGirl.create(:admin_user) }
  let(:article) { FactoryGirl.create(:article) }
  before { login(admin) }

  scenario "admin can preview article changes" do
    new_name = "Edited name"
    visit edit_admin_article_path(article)
    fill_in "Name", with: new_name
    click_on "Preview" 

    sleep(5)
    preview_page = page.driver.browser.window_handles.last
    page.driver.browser.switch_to.window(preview_page)

    expect(page).to have_content("PREVIEW WARNING")
    expect(page).to have_content(new_name)
  end
end
