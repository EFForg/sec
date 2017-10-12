FactoryGirl.define do
  factory :blog_post do
    name "A blog post"
    body "Some text"
    published_at Time.now
  end
end
