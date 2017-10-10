require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  before do
    Homepage.create(welcome: "", articles_intro: "").tap do |homepage|
      homepage.featured_topics << FactoryGirl.create(:topic)
      homepage.featured_articles << FactoryGirl.create(:article)
      homepage.featured_blog_post = FactoryGirl.create(:blog_post)
      homepage.save!
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
