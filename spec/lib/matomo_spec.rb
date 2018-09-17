require "rails_helper"
require "matomo"

RSpec.describe Matomo do
  it "gets top articles" do
    puts Matomo.top_articles
  end

  it "gets top lesson topics" do
    puts Matomo.top_lesson_topics
  end
end
