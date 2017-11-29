require 'rails_helper'

RSpec.feature "ViewHomepage", type: :feature do
  let(:homepage) { FactoryGirl.create(:homepage) }

  scenario "user visits the homepage and sees populated content" do
    visit root
    
  end
end
